# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :huephix,
  ecto_repos: [Huephix.Repo]

# Configures the endpoint
config :huephix, HuephixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aOEwBIOE7jhY77Co2ynYLP6ZMBsBs6BdqMR+UYOBqvleNrs6R+31eRoHntz6y7wr",
  render_errors: [view: HuephixWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Huephix.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Hue specific configurations
config :huephix, hue_application_name: "huephix",
  number_of_alert_blinks: 3

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
