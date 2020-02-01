defmodule AppWeb.GithubAuthController do
  use AppWeb, :controller

  @doc """
  `index/2` handles the callback from GitHub Auth API redirect.
  """
  def index(conn, %{"code" => code}) do
    # {:ok, token} = ElixirAuthGithub.get_token(code, conn)
    {:ok, profile} = ElixirAuthGithub.github_auth(code)
    IO.inspect profile, label: "profile"
    conn
    |> put_view(AppWeb.PageView)
    |> render(:welcome, profile: profile)
  end
end
