defmodule AppWeb.PageController do
  use AppWeb, :controller

  def index(conn, _params) do
    oauth_github_url = ElixirAuthGithub.login_url_with_scope(["user:email"])
    render(conn, "index.html", [oauth_github_url: oauth_github_url])
  end
end
