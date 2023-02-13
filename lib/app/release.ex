defmodule App.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :app

  def migrate do
    load_app()
  end

  def rollback(_repo, _version) do
    load_app()
  end

  defp load_app do
    Application.load(@app)
  end
end
