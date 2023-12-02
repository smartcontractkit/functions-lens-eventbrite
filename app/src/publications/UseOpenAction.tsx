import { textOnly } from "@lens-protocol/metadata";
import {
  isPostPublication,
  OpenActionKind,
  OpenActionType,
  PublicationId,
  TriStateValue,
  useCreatePost,
  useOpenAction,
  usePublication,
} from "@lens-protocol/react-web";
import { useState, useEffect } from "react";
import { toast } from "react-hot-toast";

import { Logs } from "../components/Logs";
import { ErrorMessage } from "../components/error/ErrorMessage";
import { Loading } from "../components/loading/Loading";
import { useLogs } from "../hooks/useLogs";
import { uploadJson } from "../upload";
import { invariant } from "../utils";
import { PublicationCard } from "./components/PublicationCard";
import { ethers } from "ethers";

// Setup data to send to the Open Action Smart Contract
let JS_SOURCE = "";

// env vars are read from .env or .env.local files
const ORG_ID = import.meta.env.VITE_ORG_ID;
const EVENT_ID = import.meta.env.VITE_EVENT_ID;

const abiEncoder = ethers.utils.defaultAbiCoder;
const donHostedSecretsSlotId = 0; // TODO @dev put your secrets slot ID here if youve choses something other than 0
const donHostedSecretsVersion = 1701401497; // TODO @dev put your secrets version here
const percentageOff = "65"; // TODO @dev put your percentage off here
const quantityAvailable = "20"; // TODO @dev put your quantity available here

const filepath = "../../source.js";
fetch(filepath)
  .then(response => response.text())
  .then(data => {
    JS_SOURCE = data;
  })
  .catch(err => {
    alert("Error loading JS_SOURCE: " + err);
  });

// Main React Component
export function UseOpenAction() {
  const [publicationId, setPublicationId] = useState<PublicationId | undefined>(
    undefined // Optional TODO @dev put your publication ID here if you want to load a pre-existing one
  );
  const [contractAddress, setContractAddress] = useState("");
  const [discountCode, setDiscountCode] = useState("");
  const { logs, clear, log } = useLogs();

  //  Mount event listener for DiscountCode event emitted by Open Action Smart Contract
  useEffect(() => {
    if (!contractAddress) return;

    let activeAccount: string;

    const init = async () => {
      try {
        const accounts = await window.ethereum.request({
          method: "eth_requestAccounts",
        });
        activeAccount = accounts[0]; // The first account is the active one
        console.log("Active Account is:  ", activeAccount);
      } catch (error) {
        console.error("Error getting the active wallet:", error);
      }

      const abi = [
        "event DiscountCode(address indexed requester, string discountCode)",
      ];

      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const contractInstance = new ethers.Contract(
        contractAddress,
        abi,
        provider
      );

      const filter = contractInstance.filters.DiscountCode(activeAccount);
      contractInstance.on(filter, (requester, discountCode, event) => {
        console.log("Event: ", event);
        console.log(`${requester} has recieved discount code: ${discountCode}`);
        setDiscountCode(discountCode);
      });
    };

    init();
  }, [contractAddress]);

  return (
    <div>
      <h1>
        <code>useOpenAction</code>
      </h1>
      {!publicationId && (
        <>
          {logs.length === 0 && (
            <CreatePostWithOA
              setPublicationId={setPublicationId}
              contractAddress={contractAddress}
              setContractAddress={setContractAddress}
              clear={clear}
              log={log}
              logs={logs}
            ></CreatePostWithOA>
          )}
          <Logs logs={logs} />
        </>
      )}

      {discountCode && (
        <article>
          <p>
            Here is your Event Discount Code:{" "}
            <span style={{ color: "blue" }}>
              <a
                href={`http://www.eventbrite.com/event/${EVENT_ID}/?discount=${discountCode}`}
              >
                {discountCode}
              </a>
            </span>
          </p>
        </article>
      )}

      {publicationId && !discountCode && (
        <DisplayPublication
          id={publicationId}
          log={log}
          clear={clear}
          logs={logs}
          contractAddress={contractAddress}
        />
      )}
    </div>
  );
}

// ============================================================== //
// ======  DISPLAY HELPER FUNCTIONS / Child Components ====== //
// ============================================================== //

function CreatePostWithOA({
  setPublicationId,
  contractAddress,
  setContractAddress,
  clear,
  log,
  logs,
}) {
  const POST_TEXT =
    "Hello, world! This post includes a Custom Open Action For Discount Codes on Events I'm Hosting. Click on the button below to get a discount code for my event.";

  const { execute: createPost } = useCreatePost();

  // Function to handle input changes
  const handleInputChange = e => {
    // Update the state with the input value as the user types
    setContractAddress(e.target.value);
  };

  const createPostWithOA = async () => {
    setPublicationId(undefined);
    clear();

    if (!ethers.utils.isAddress(contractAddress)) {
      window.alert(
        "Invalid contract address. Please enter a valid contract address."
      );
      setContractAddress("");
      return;
    }

    const metadata = textOnly({
      content: POST_TEXT,
    });

    const contentUri = await uploadJson(metadata);
    log("Uploading metadata...please sign the transaction in your wallet");

    // publish post
    // Encode Data used to initialize the Open Action Smart Contract with its `initializePublicationAction()` method.
    // This method on the contract gets called automatically by Lens Protocol when you publish a post with an Open Action.
    const abiEncodedInitData = abiEncoder.encode(
      ["uint8", "uint64", "string", "string"],
      [
        donHostedSecretsSlotId,
        donHostedSecretsVersion,
        percentageOff,
        quantityAvailable,
      ]
    );

    clear();
    log("Creating your post...please sign the transaction in your wallet");

    const result = await createPost({
      metadata: contentUri,
      actions: [
        {
          type: OpenActionType.UNKNOWN_OPEN_ACTION,
          address: contractAddress,
          data: abiEncodedInitData,
        },
      ],
    });

    console.log(
      "ABI Encoded Data passed to initializePublicationAction():  ",
      abiEncodedInitData
    );

    // check for failure scenarios
    if (result.isFailure()) {
      toast.error(result.error.message);
      return;
    }

    clear();
    log("Loading your post...");

    // wait for full completion
    const completion = await result.value.waitForCompletion();

    // check for late failures
    if (completion.isFailure()) {
      toast.error(completion.error.message);
      return;
    }

    // post was created
    const post = completion.value;
    toast.success(`Post ID: ${post.id}`);
    console.log("Post upload OK.  Post: ", post);

    setPublicationId(completion.value.id);
    clear();
  };

  return (
    <>
      <div>
        <h3>Enter Your Functions & Open Action Smart Contract Address</h3>
        <form>
          <input
            type="text"
            value={contractAddress}
            onChange={handleInputChange}
            placeholder="0x..."
          />
        </form>

        <p>
          Your Open Action With Functions Contract Address: {contractAddress}
        </p>
      </div>
      <button type="button" onClick={createPostWithOA}>
        Create Sample Post With Open Action
      </button>
    </>
  );
}

function DisplayPublication({
  id,
  log,
  clear,
  logs,
  contractAddress,
}: {
  id: PublicationId;
}) {
  const { data: publication, loading, error } = usePublication({ forId: id });

  // Encode Data to trigger Open Action Smart Contract and initiate Functions Request.
  // Data will be received in the `processPublicationAction(processActionParams)` method
  //  as bytes in `ProcessActionParams.actionModuleData`
  const abiEncodedProcessPublicationData = abiEncoder.encode(
    ["string", "string", "string"],
    [ORG_ID, EVENT_ID, JS_SOURCE]
  );

  // setup the useOpenAction hook to initialize the Open Action contract.
  const { execute: getDiscount } = useOpenAction({
    action: {
      kind: OpenActionKind.UNKNOWN,
      address: contractAddress,
      data: abiEncodedProcessPublicationData,
    },
  });

  console.log("Publication retrieved:  ", publication);
  // Handler
  const callOpenActionForDiscount = async () => {
    clear();

    log("Calling Open Action...please sign the transaction in your wallet");
    const result = await getDiscount({
      publication,
      // sponsored: false, 
    });
    console.log(
      "ABI Encoded Data passed to processPublicationAction():  ",
      abiEncodedProcessPublicationData
    );
    console.log("Result: ", result);

    if (result.isFailure()) {
      toast.error(result.error.message);
      return;
    }
    const completion = await result.value.waitForCompletion();
    console.log("Completion:  ", completion);
    if (completion.isFailure()) {
      toast.error(completion.error.message);
      return;
    }
    toast.success(`You successfully requested your event discount code.`);
  };

  // Render
  if (loading) {
    return <Loading />;
  }

  if (error) {
    return <ErrorMessage error={error} />;
  }
  invariant(isPostPublication(publication), "Publication is not a post");

  return (
    <div>
      <PublicationCard publication={publication} />
      <button
        onClick={callOpenActionForDiscount}
        disabled={publication.operations.canCollect === TriStateValue.No}
      >
        Get Discount Code
      </button>

      {/* Display details of Post with OA when created */}
      {publication.id && (
        <div className="notice">
          {
            <>
              <h4> Uploaded your post...</h4>
              <p>Post URL: {publication.metadata.rawURI}</p>
              <p>Post ID: {publication.id}</p>
            </>
          }
        </div>
      )}

      {logs.length !== 0 && <Logs logs={logs} />}

      <div className="notice">
        <p>
          At the time of this example writing there are 2 known API issues:
          <br></br>
        </p>
        <ul>
          <li>
            <code>PublicationStats.collects</code> (alias) returns{" "}
            <code>0</code> when mined.
          </li>
          <li>
            <code>PublicationOperations.canCollect</code> (alias) returns always{" "}
            <code>false</code>
          </li>
        </ul>
      </div>
    </div>
  );
}
