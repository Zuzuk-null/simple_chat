defmodule SimpleChat.User do
  use GenServer

  def init(uid), do: {:ok, uid}

  def start_link(uid), do:
    GenServer.start_link(__MODULE__, uid, name: via_tuple(uid))

  defp via_tuple(uid), do:
    {:via, :gproc, {:n, :l, {:chat_user, uid}}}

  def cast_handle({:msg, msg}, id), do:
    Nadia.send_message(id, msg)

end
