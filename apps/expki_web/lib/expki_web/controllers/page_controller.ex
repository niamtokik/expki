defmodule ExpkiWeb.PageController do
  use ExpkiWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
