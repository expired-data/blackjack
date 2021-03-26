FROM elixir:1.11.1-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm git

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# copy umbrella apps
COPY apps/blackjack apps/blackjack
COPY apps/blackjack_server/lib apps/blackjack_server/priv apps/blackjack_server/test apps/blackjack_server/mix.exs apps/blackjack_server/

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile


COPY apps/blackjack_server/priv apps/blackjack_server/priv

# compile and build release
COPY . .
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

ENV TCP_PORT=4000 \
    MIX_ENV=prod \
    SHELL=/bin/sh 

COPY --from=build app/_build/prod/rel/blackjack_umbrella .

CMD ["./bin/blackjack_umbrella", "start"]