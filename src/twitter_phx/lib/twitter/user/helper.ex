defmodule Twitter.User.Helper do

  def merge_atoms(atom1, atom2) do
    "#{inspect atom1}_#{inspect atom2}"
    |> String.to_atom
  end

  def get_agnt(u_name_atom, :followers), do: merge_atoms(u_name_atom, :followers)
  def get_agnt(u_name_atom, :follow_to), do: merge_atoms(u_name_atom, :follow_to)
 def get_agnt(u_name_atom, :tweets), do: merge_atoms(u_name_atom, :tweets)

end
