# Madek GraphQL API

⚠️ **STATUS: EXPERIMENTAL, WORK IN PROGRESS** ⚠️

<img src="https://raw.githubusercontent.com/lhl/pusheen-stickers/master/gif/pusheen/144884865685780.gif" alt="cute cartoon cat typing on laptop"/>

## #goals

- GraphQL API for Sets, Entries, Metadata, Previews (e.g. enough data for a Lightbox gallery)
- read-only data (only `query`, no `mutation`)
- only public data (no auth, no access control except the `get_*` fields)
- no hard dependencies on other parts of Madek except read-only access
  - (local development environment shares some code like DB migrations)
- fully tested with RSpec (maybe turnip?)
  - test data in db + query + variables => expect result
  - schema, incl. backwards compat tracking
  - perf testing? (relative query runtime?)
- performance: should be fast enough to render gallery of 100 photos in set server-side and retain reasonable loading time
  - efficient batching / pagination
  - (SQL) query optimization
- basic "evil" query protection (maximum depth, timeouts)

reading material:

- https://graphql.org/learn/
- https://madek.readthedocs.io/en/latest/architecture/entities/#public-resources
- https://graphql-ruby.org
- https://www.youtube.com/watch?v=Wlu_PWCjc6Y (advanced)
- https://github.com/chentsulin/awesome-graphql (more resources)

## development setup

install

```shell
git clone https://github.com/Madek/madek-graphql-api && cd madek-graphql-api
git submodule update --recursive --init --force
bundle && cd datalayer && bundle && cd -
```

config

```shell
cd datalayer
cp config/database_developer_example.yml config/database.yml
# edit config/database.yml
cd -
```

reset db && startup

```shell
./scripts/dev-reset
PORT=4321 ./scripts/start-dev-server
```

helpers

- https://github.com/prisma/graphql-playground

## example queries

```graphql
query {
  mediaEntry(id: "06622f9c-8f41-43eb-a4a4-fd3b8444de64") {
    id
    createdAt
  }
}
```

=>

```json
{
  "data": {
    "mediaEntry": {
      "id": "06622f9c-8f41-43eb-a4a4-fd3b8444de64",
      "createdAt": "2012-10-16 13:57:54 UTC"
    }
  }
}
```
