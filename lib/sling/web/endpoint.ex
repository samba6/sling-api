defmodule Sling.Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :sling

  socket "/socket", Sling.Web.UserSocket

  plug Plug.Static.IndexHtml,
  at: "/"

  plug Plug.Static,
  at: "/",
  # from: {:phoenix_graphql, "web-client/"},
  from:  "web-client/",
  # only: ~w(index.html favicon.ico static service-worker.js)
  only_matching: ~w(index.html favicon manifest robots.txt static service)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_sling_key",
    signing_salt: "NBWPwNEM"

  plug Corsica, origins: "*",
    allow_headers: ~w(Accept Content-Type Authorization Origin)
  plug Sling.Web.Router

  @doc """
  Dynamically loads configuration from the system environment
  on startup.

  It receives the endpoint configuration from the config files
  and must return the updated configuration.
  """
  def load_from_system_env(config) do
    port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
    {:ok, Keyword.put(config, :http, [:inet6, port: port])}
  end
end
