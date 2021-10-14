defmodule OlePassoWeb.MealWheelLive do
  use OlePassoWeb, :live_view

  def mount(_, _, socket) do
    # if connected?(socket) do
    #   :timer.send_interval(1000, self(), :tick)
    # end

    socket = assign(socket, item: "salut", rotation: 0)
    {:ok, socket}
  end

  def handle_info(:tick, socket) do
    socket = assign(socket, :rotation, &(&1 + 1))
    {:noreply, socket}
  end

  def handle_event("add", _, socket) do
    socket = assign(socket, :item, "hello")
    {:noreply, socket}
  end

  def handle_event("rotate", _, socket) do
    socket = update(socket, :rotation, &(&1 + 180))
    {:noreply, socket}
  end
end
