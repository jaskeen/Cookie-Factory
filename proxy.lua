--
-- proxy.lua
-- Adds "propertyUpdate" events to any Corona display object.
-- From: http://blog.anscamobile.com/2012/05/tutorial-property-callbacks/
--[[
IMPORTANT

In your listener function (for these “propertyUpdate” events), if you want to change another property of the same display object, be sure to use ‘self’ instead of event.target.

In regards to the “propertyUpdate” listener, using ‘self’ will not invoke any metamethods, while event.target will. Since the “propertyUpdate” listener function is called from within a metamethod (see proxy.lua source), changing properties on event.target will create an infinite loop and cause your app to crash.

To be clear: use ‘self’ if you need to change other properties of the display object within the “propertyUpdate” event listener. 

]]

local m = {}

function m.get_proxy_for( obj )
  local t = {}
  local mt =
  {
    __index = function(tb,k)
      -- pass method and property requests to the display object
      if type(obj[k]) == 'function' then
        return function(...) arg[1] = obj; obj[k](unpack(arg)) end
      else
        return obj[k]
      end
    end,

    __newindex = function(tb,k,v)
      -- dispatch event before property update
      local event =
      {
        name = "propertyUpdate",
        target=tb,
        key=k,
        value=v
      }
      obj:dispatchEvent( event )

      -- update the property on the display object
      obj[k] = v
    end
  }
  setmetatable( t, mt )

  return t
end

return m