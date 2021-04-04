employees = [
  %{department: :engineering, name: "Dilbert"},
  %{department: :management, name: "Pointy Haired Boss"},
  %{department: :engineering, name: "Wally"},
  %{department: :hr, name: "Catbert"},
  %{department: :marketing, name: "Ted"},
  %{department: :management, name: "Egghead"},
  %{department: :engineering, name: "Alice"},
]

departments = Enum.group_by(employees, &(&1.department), &(&1.name))
IO.inspect departments
