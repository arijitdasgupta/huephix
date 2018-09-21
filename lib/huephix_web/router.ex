defmodule HuephixWeb.Router do
  use HuephixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HuephixWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api/v1", HuephixWeb do
    resources "/lights", LightsController, singleton: true do
      post "/on", LightsController, :on, as: :on
      post "/off", LightsController, :off, as: :off
      post "/brightness", LightsController, :brightness, as: :brightness
      post "/blink", LightsController, :blink, as: :blink
      post "/scene", LightsController, :scene, as: :scene
      post "/loop/start", LightsController, :loop_start, as: :loop_start
      post "/loop/stop", LightsController, :loop_stop, as: :loop_stop
    end
  end
end
