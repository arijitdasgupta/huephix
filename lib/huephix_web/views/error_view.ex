defmodule HuephixWeb.ErrorView do
  use HuephixWeb, :view
  alias HuephixWeb.ErrorHelpers

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".

  def render("409.validation.json", %{changeset: changeset}) do
    %{errors: Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)}
  end

  def render("500.json", _) do
    %{error: "Something went wrong"}
  end

  def render("404.json", _) do
    %{error: "Not found"}
  end

  def render("400.json", _) do
      %{error: "Bad request"}
  end

  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
