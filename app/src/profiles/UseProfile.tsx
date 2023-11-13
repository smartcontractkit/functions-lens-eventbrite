import { profileId, useProfile, useSession } from "@lens-protocol/react-web";

import { ErrorMessage } from "../components/error/ErrorMessage";
import { Loading } from "../components/loading/Loading";
import { ProfileCard } from "./components/ProfileCard";

const userHandle: string =   "test/" + "@TODOProfileIdHere" // @TODO dev. Exclude the `@` character.

export function UseProfile() {
  const {
    data: profile,
    error,
    loading,
  } = useProfile({ forHandle: userHandle });
  // const { data: profile, error, loading } = useProfile({forProfileId:profileId(_profileId)});

  if (loading) return <Loading />;

  console.log("Loaded profile : ", profile)
  if (error) return <ErrorMessage error={error} />;

  return <ProfileCard profile={profile} />;
}
