defmodule AppWeb.PageControllerTest do
  use AppWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Welcome to Awesome App!"
  end
end
