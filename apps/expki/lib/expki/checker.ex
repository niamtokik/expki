defmodule Expki.Checker do
  @moduledoc ~S"""
  A simple pipeline of functions to check values. It can also be used
  to convert value and so on.
  """

  @type check_input :: term()
  @type check_functions :: [function()]
  @type check_state :: term()
  @type check_result :: :ok | {:ok, check_state} | :error | {:error, term()}

  @doc """
  Check input using a list of functions.

  ## Examples

      iex> check(<<>>, [])
      {:ok, <<>>}
  """
  @spec check(check_input(), check_functions(), check_state()) :: check_result()
  def check(data, functions, state \\ %{}) do
    check_loop(data, functions, state)
  end

  @spec check_loop(check_input(), check_functions(), check_state()) :: check_result()
  defp check_loop(data, [], _state), do: {:ok, data}
  defp check_loop(data, [fun|funs], state) do
    try do
      result = fun.(data, state)
      evaluate(result, data, funs, state)
    rescue
      error -> {:error, %{reason: error, data: data}}
    catch
      error -> {:error, %{reason: error, data: data}}
    end
  end

  @spec evaluate(check_result(), check_input(), check_functions(), check_state()) :: check_result()
  defp evaluate(:ok, data, funs, state) do
    check_loop(data, funs, state)
  end
  defp evaluate({:ok, new_state}, data, funs, _state) do
    check_loop(data, funs, new_state)
  end
  defp evaluate(:error, data, _funs, state) do
    {:error, %{data: data, state: state}}
  end
  defp evaluate({:error, reason}, data, _funs, state) do
    {:error, %{data: data, state: state, reason: reason}}
  end
  defp evaluate(other, data, _funs, state) do
    {:error, %{data: data, state: state, reason: {:bad_return, other}}}
  end

end
