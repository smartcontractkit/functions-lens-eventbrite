import { profileId, useProfile, useSession } from "@lens-protocol/react-web";

import { ErrorMessage } from "../components/error/ErrorMessage";
import { Loading } from "../components/loading/Loading";
import { ProfileCard } from "./components/ProfileCard";

const userHandle: string = "test/" + "TODOProfileHandleHere"; //  @TODO dev -- exclude the `@` character.

export function UseProfile() {
  const {
    data: profile,
    error,
    loading,
  } = useProfile({ forHandle: userHandle });
  // const { data: profile, error, loading } = useProfile({forProfileId:profileId(_profileId)});

  if (loading) return <Loading />;
  console.log("Loaded profile : ", profile);
  if (error)
  error.message = error.message + " - please check the UseProfile.tsx Component "
    return (
      <ErrorMessage
        error={error}
      />
    );

}
