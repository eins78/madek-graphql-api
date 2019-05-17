import React, { Fragment, useState } from "react";
import PropTypes from "prop-types";
import { useQuery } from "graphql-hooks";
import ErrorMessage from "./error-message";
import FakeFancybox from "./fake-fancybox-gallery";

export const mediaEntryQuery = /* GraphQL */ `
  query firstMediaEntry($id: ID!) {
    mediaEntry(id: $id) {
      id
      title
      createdAt
    }
  }
`;

export default function EntryShow({ entryId }) {
  const { loading, error, data, refetch, cacheHit, ...errors } = useQuery(
    mediaEntryQuery,
    {
      variables: {
        id: entryId
      }
    }
  );

  if (error) return <ErrorMessage message="Error loading." details={errors} />;
  if (loading || !data) return <div>Loading</div>;

  return (
    <Fragment>
      <section>
        <h1>{data.mediaEntry.title}</h1>

        <hr />

        <h2>
          <small>gallery with fake data but working fancybox:</small>
        </h2>
        <FakeFancybox />
      </section>
    </Fragment>
  );
}

EntryShow.propTypes = {
  entryId: PropTypes.string.isRequired
};
