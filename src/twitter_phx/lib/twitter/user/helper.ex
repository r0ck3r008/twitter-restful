defmodule Twitter.User.Helper do

  def merge_atoms(atom1, atom2) do
    "#{inspect atom1}_#{inspect atom2}"
    |> String.to_atom
  end

  def get_agnt(u_name_atom, :followers), do: merge_atoms(u_name_atom, :followers)
  def get_agnt(u_name_atom, :follow_to), do: merge_atoms(u_name_atom, :follow_to)
  def get_agnt(u_name_atom, :tweets), do: merge_atoms(u_name_atom, :tweets)

  def get_mentions(u_name, state) do
    tweet_l=for {tweeter, tweet_l}<-state do
      for tweet<-tweet_l do
        mention=Regex.match?(~r/@#{String.slice("#{inspect u_name}", 1, 1500)}/, tweet)
        case mention do
          true
          ->
            %{tweeter: tweeter, tweet: tweet}
          false
          ->
            nil
        end
      end
    end
    Enum.uniq(List.flatten(tweet_l))--[nil]
  end

end
