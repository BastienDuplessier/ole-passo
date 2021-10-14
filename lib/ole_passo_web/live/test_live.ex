defmodule OlePassoWeb.TestLive do
  use OlePassoWeb, :live_view
  @values1 [1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 5, 6]
  @values2 [1, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 5, 6]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, dices: [1, 1], dice_throw: :idle)}
  end

  @impl true
  def handle_event("throw_dices", _params, %{assigns: %{dice_throw: state}} = socket)
      when state != :running do
    send(self(), {:tumble_dices, {1, 1}, 0, 20})
    {:noreply, assign(socket, :dice_throw, :running)}
  end

  def handle_event("throw_dices", _params, socket) do
    IO.inspect(socket)
    {:noreply, socket}
  end

  def handle_info({:tumble_dices, {a, a}, max, max}, socket) do
    IO.inspect("finished double")
    {:noreply, assign(socket, :dice_throw, :double)}
  end

  def handle_info({:tumble_dices, {a, b}, max, max}, socket) do
    IO.inspect("finished")

    with true <- (a == 3 && b == 4) || (a == 4 && b == 3) do
      {:noreply, assign(socket, :dice_throw, :victory)}
    else
      _ ->
        {:noreply, assign(socket, :dice_throw, :fail)}
    end
  end

  def handle_info({:tumble_dices, {a, b}, count, max}, socket) when count < max do
    Process.sleep(50)
    IO.inspect("Turn #{count}/#{max} : #{a} - #{b}")
    new_a = Enum.random(@values1 -- [a])
    new_b = Enum.random(@values2 -- [b])
    send(self(), {:tumble_dices, {new_a, new_b}, count + 1, max})
    {:noreply, assign(socket, :dices, [new_a, new_b])}
  end
end
