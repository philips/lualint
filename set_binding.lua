require("msys.core")

local mod = {}

-- set_binding can be called from multiple threads,
-- so you should not use globals to make binding decisions.
function mod:validate_set_binding(msg)
  blat = 2 -- Oops, setting a global.
  if fred == 1 then -- Oops, reading a global.
    msg:set_binding("fred")
  end
end

msys.registerModule(mod, "set_binding")

