# README

## development setup

install

```shell
git submodule update --recursive --init --force
bundle && cd datalayer && bundle && cd -
```

config

```shell
cd datalayer
cp config/database_developer_example.yml config/database.yml
# edit config/database.yml
```

reset db && startup

```shell
./scrips/dev-reset
PORT=4321 ./scripts/start-dev-server
```
