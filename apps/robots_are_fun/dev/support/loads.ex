defmodule RobotsAreFun.Support.Loads do
  alias RobotsAreFun.Inventory.Load

  def loads() do
    [
      %Load{id: "4", x: 36, y: 86},
      %Load{id: "23", x: 12, y: 45},
      %Load{id: "76", x: 67, y: 22},
      %Load{id: "91", x: 50, y: 81},
      %Load{id: "15", x: 71, y: 49}
    ]
  end
end
