global_settings = "~/.iex.exs"
if File.exists?(global_settings), do: Code.require_file(global_settings)

import Ecto.Query

alias Rumbl.Repo
alias Rumbl.Accounts
alias Rumbl.Accounts.{User, Credential}
alias Rumbl.Multimedia
alias Rumbl.Multimedia.{Video, Category}

alias RumblWeb.Router.Helpers, as: Routes