defmodule TwitterSimulated.Test do

  import Ecto.Query, only: [from: 2]

  def fetch_users do
    query = from u in "users",
            select: u.uname

    Twitter.Repo.all(query)
    |> IO.inspect
  end

end

TwitterSimulated.Test.fetch_users
