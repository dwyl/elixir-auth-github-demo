import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :app, AppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Hgwn7B7v8EcxKAGpJ65aTAmpz2dKRTUGG3q1wquHD88VG4Tfm0IyH8bJvUsqNLSC",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :elixir_auth_github,
  client_id: "d6fca75c63daa014c187",
  client_secret: "8eeb143935d1a505692aaef856db9b4da8245f3c",
  httpoison_mock: true
