defmodule AppWeb.GithubAuthControllerTest do
  use AppWeb.ConnCase

  test "GET /auth/github/callback", %{conn: conn} do
    conn = get(conn, "/auth/github/callback", %{"code" => "12345"})
    assert html_response(conn, 200) =~ "signed in"
  end
end
