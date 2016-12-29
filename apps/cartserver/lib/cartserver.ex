defmodule Cartserver do
  def events(cart) do
    cart
  end

  def event(cart, new_event) do
    [ new_event | cart ]
  end

  def filter_by_event(cart, event) do
    Enum.filter(cart, fn({e, _}) -> e == event end)
  end

  defp fetch_quantities(cart) do
    Enum.map(cart, fn({_, item}) -> Map.get(item, :qty, 0) end)
  end

  defp quantities(cart, event) do
    filter_by_event(cart, event)
    |> fetch_quantities
  end

  defp negate(list) do
    Enum.map(list, fn(x) -> x * -1 end)
  end

  def count(cart) do
    quantities(cart, :add) ++ negate(quantities(cart, :remove))
    |> Enum.reduce(fn(x, acc) -> x + acc end)
  end

  defp fetch_extended_totals(cart) do
    Enum.map(cart, fn({_, item}) -> Map.get(item, :qty, 0) * Map.get(item, :price, 0) end)
  end

  defp extended_totals(cart, event) do
    filter_by_event(cart, event)
    |> fetch_extended_totals
  end

  def total(cart) do
    extended_totals(cart, :add) ++ negate(extended_totals(cart, :remove))
    |> Enum.reduce(fn(x, acc) -> x + acc end)
  end

  def find_all_removes(cart) do
    filter_by_event(cart, :remove)
  end

  defp match_all_removes do
    find_all_removes
    |> Enum.filter(cart, fn(a,_) -> a == :add end)
  end

  # def resolve do
  #
  # end
end
