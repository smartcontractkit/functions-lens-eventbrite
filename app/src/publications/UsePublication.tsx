import { publicationId, usePublication } from "@lens-protocol/react-web";

import { ErrorMessage } from "../components/error/ErrorMessage";
import { Loading } from "../components/loading/Loading";
import { PublicationCard } from "./components/PublicationCard";

// const PUBLICATION_ID = "0x-TODO-TODO-0x01-DA"; // TODO @dev put your post (publication) ID here
const PUBLICATION_ID = "0x0171-0x32"; // TODO @dev put your post (publication) ID here

export function UsePublication() { 
  const {
    data: publication,
    error,
    loading,
  } = usePublication({
    forId: publicationId(PUBLICATION_ID),
  });

  if (loading) return <Loading />;

  if (error) {
    error.message = error.message + " - please check the UsePublication.tsx Component "  
    return <ErrorMessage error={error} />;
  }

  console.log("Publication fetched .. ", publication)

  return (
    <div>
      <h1>
        <code>usePublication</code>
      </h1>
      <PublicationCard publication={publication} />
    </div>
  );
}
