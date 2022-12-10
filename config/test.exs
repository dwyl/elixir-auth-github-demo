import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :app, AppWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :app, App.Repo,
  username: "postgres",
  password: "postgres",
  database: "app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :elixir_auth_github,
  client_id: "d6fca75c63daa014c187",
  client_secret: "8eeb143935d1a505692aaef856db9b4da8245f3c",
  httpoison_mock: true
