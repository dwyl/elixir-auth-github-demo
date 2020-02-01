defmodule AppWeb.PageController do
  use AppWeb, :controller

  def index(conn, _params) do
    scopes = ["user", "user:email"]
    oauth_github_url = ElixirAuthGithub.login_url_with_scope(scopes)
    IO.inspect oauth_github_url
    render(conn, "index.html", [oauth_github_url: oauth_github_url])
  end
end
