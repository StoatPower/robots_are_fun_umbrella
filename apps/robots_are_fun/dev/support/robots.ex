defmodule RobotsAreFun.Support.Robots do
  alias RobotsAreFun.Fleet.Robot

  def robots() do
    {:ok,
      [
        # these are the first 10 from the test api
        %Robot{id: "47", battery_level: 0, x: 51, y: 38},
        %Robot{id: "75", battery_level: 97, x: 5, y: 33},
        %Robot{id: "74", battery_level: 45, x: 59, y: 43},
        %Robot{id: "7", battery_level: 24, x: 13, y: 66},
        %Robot{id: "90", battery_level: 28, x: 91, y: 62},
        %Robot{id: "27", battery_level: 91, x: 75, y: 11},
        %Robot{id: "43", battery_level: 59, x: 49, y: 20},
        %Robot{id: "25", battery_level: 51, x: 24, y: 8},
        %Robot{id: "14", battery_level: 66, x: 57, y: 88},
        %Robot{id: "8", battery_level: 62, x: 91, y: 96},
        # these three are added and are within close range
        # of the first load in the list of test loads
        %Robot{id: "111", battery_level: 21, x: 34, y: 86},
        %Robot{id: "222", battery_level: 66, x: 27, y: 86},
        %Robot{id: "333", battery_level: 70, x: 26, y: 87},
      ]
      |> Enum.into(Map.new(), fn r -> {r.id, r} end)
    }
  end
end
