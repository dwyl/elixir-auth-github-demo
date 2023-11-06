defmodule AppWeb.PageController do
  use AppWeb, :controller

  def home(conn, _params) do
    oauth_github_url = ElixirAuthGithub.login_url(%{scopes: ["user:email"]})
    render(conn, :home, layout: false, oauth_github_url: oauth_github_url)
  end
end
