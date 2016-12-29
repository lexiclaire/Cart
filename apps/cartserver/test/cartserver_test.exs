defmodule CartserverTest do
  use ExUnit.Case
  doctest Cartserver

  test "an empty cart is empty" do
    assert Cartserver.events([]) == []
  end

  test "we can record events about empty cart" do
    c = Cartserver.event([], {:add, :item}) |> Cartserver.event({:remove, :item})
    assert Cartserver.events(c) == [{:remove, :item}, {:add, :item}]
  end

  test "we can get a count of items in a cart" do
    q1 = Enum.random(0..10)
    q2 = Enum.random(0..10)
    c = Cartserver.event([], {:add, %{qty: q1}}) |> Cartserver.event({:add, %{qty: q2}})
    assert Cartserver.count(c) == q1 + q2
  end

  test "we can get the value of the cart" do
    item1 = %{qty: Enum.random(0..10), price: Enum.random(0..500)/100}
    item2 = %{qty: Enum.random(0..10), price: Enum.random(0..500)/100}
    total = item1[:qty] * item1[:price] + item2[:qty] * item2[:price]
    c = Cartserver.event([], {:add, item1}) |> Cartserver.event({:add, item2})
    assert Cartserver.total(c) == total
  end

  test "we can resolve remove events" do
    item1 = %{name: "milk", qty: Enum.random(0..10)}
    item2 = %{name: "milk", qty: Enum.random(0..10)}
    c = Cartserver.event([], {:add, item1}) |> Cartserver.event({:remove, item2})
    expected = item1[:qty] - item2[:qty] 
    assert expected == Cartserver.resolve(c)
  end
end
