
function load_level(file)
  local tbl, row = {}, {}

  for line in io.lines(file) do
    for digit in line:gmatch("[0-4]") do
      table.insert(row, tonumber(digit))
    end

    table.insert(tbl, row)
    row = {}
  end

  return tbl
end
