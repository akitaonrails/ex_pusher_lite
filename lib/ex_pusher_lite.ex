defmodule ExPusherLite do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(ExPusherLite.Endpoint, []),
      # Start the Ecto repository
      worker(ExPusherLite.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(ExPusherLite.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExPusherLite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ExPusherLite.Endpoint.config_change(changed, removed)
    :ok
  end

  # Return this applicaton administration Basic HTTP Auth hash
  # FIXME: This is probably weak and we should implement Guardian JWT, but it will do for now
  def admin_secret do
    admin_username = Application.get_env(:ex_pusher_lite, :admin_authentication)[:username]
    admin_password = Application.get_env(:ex_pusher_lite, :admin_authentication)[:password]
    secret = Base.encode64("#{admin_username}:#{admin_password}")
  end
end
