# Huephix

## Fix your Philips Hue...

An application that adds features to your existing Philips Hue system, and has easy to use webhooks for all your IFTTT integration needs, and can ping other webhooks too.

To start your server:
  * Run `docker-compose start` or `docker-compose up` to start/run a PostgresDB as a Docker container, if you aren't alreay running one.
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:8080`](http://localhost:8080) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
