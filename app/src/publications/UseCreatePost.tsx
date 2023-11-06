import { useState } from "react";
import { textOnly } from "@lens-protocol/metadata";
import { OpenActionType, useCreatePost } from "@lens-protocol/react-web";
import { toast } from "react-hot-toast";
import { ethers } from "ethers";

import { UnauthenticatedFallback, WhenLoggedIn } from "../components/auth";
import { uploadJson } from "../upload";

const OPEN_ACTION_ADDRESS = "0xFB0A0BC7feB519a3Ddd0efa970EAe0d9dE7976CA"; // TODO @dev put your open action smart contract address here


export function UseCreatePost() {
  return (
    <div>
      <h1>
        <code>useCreatePost</code>
      </h1>

      <WhenLoggedIn>
        <PostComposer />
      </WhenLoggedIn>
      <UnauthenticatedFallback message="Log in to create a post." />
    </div>
  );
}


function PostComposer() {
  const { execute, loading, error } = useCreatePost();
  const [postId, setPostId] = useState<string>("");
  const [postURL, setPostURL] = useState<string>("");

  const submit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const form = event.currentTarget;
    const formData = new FormData(form);

    // create post metadata
    const metadata = textOnly({
      content: formData.get("content") as string,
    });

    const contentUri = await uploadJson(metadata);
    setPostURL(contentUri);

    // prep data to pass as the `data` field in `initializePublicationAction()` in the Open Actions Smart Contract.
    const abiEncoder = ethers.utils.defaultAbiCoder;

    const donHostedSecretsSlotId = 0; // TODO @dev put your secrets slot ID here
    const donHostedSecretsVersion = 12345678; // TODO @dev put your secrets version here

    const percentageOffBytes = abiEncoder.encode(["uint256"], [90]); // TODO @dev put your percentage off here
    // const percentageOffBytes = ethers.utils.formatBytes32String("90"); // TODO @dev put your percentage off here

    const quantityAvailable = 10; // TODO @dev put your quantity available here

    const abiEncodedData = abiEncoder.encode(
      ["uint8", "uint64", "bytes32", "uint64"],
      [
        donHostedSecretsSlotId,
        donHostedSecretsVersion,
        percentageOffBytes,
        quantityAvailable,
      ]
    );
    console.log("ABI Encoded Data to pass to init:  ", abiEncodedData);

    // publish post
    const result = await execute({
      metadata: contentUri,
      actions: [
        {
          type: OpenActionType.UNKNOWN_OPEN_ACTION,
          address: OPEN_ACTION_ADDRESS,
          data: abiEncodedData,
        },
      ],
    });

    // check for failure scenarios
    if (result.isFailure()) {
      toast.error(result.error.message);
      return;
    }

    // wait for full completion
    const completion = await result.value.waitForCompletion();

    // check for late failures
    if (completion.isFailure()) {
      toast.error(completion.error.message);
      return;
    }

    // post was created
    const post = completion.value;
    setPostId(post.id);

    toast.success(`Post ID: ${post.id}`);
    console.log("Post upload OK.  Post: ", post);
  };

  return (
    <>
      <form onSubmit={submit}>
        <fieldset>
          <textarea
            name="content"
            minLength={1}
            required
            rows={3}
            placeholder="What's happening?"
            style={{ resize: "none" }}
            disabled={loading}
          ></textarea>

          <button type="submit" disabled={loading}>
            Post
          </button>

          {!loading && error && <pre>{error.message}</pre>}
        </fieldset>
      </form>
      {postId && <PostDetails postId={postId} postURL={postURL}></PostDetails>}
    </>
  );
}

function PostDetails({ postId, postURL }: { postId: string; postURL: string }) {
  return (
    <>
      <h4> Uploaded your post...</h4>
      <p>Post URL: {postURL}</p>
      <p>Post ID: {postId}</p>
    </>
  );
}
