defmodule Checkout do
  def total_post(price, tax_rate) do
    price * (tax_rate + 1)
  end
end
