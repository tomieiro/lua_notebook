local runtime = require "runtime"

package.cpath = "/usr/local/lib/lua/5.3/?.so;" .. package.cpath;
local fl = require "moonfltk";

function Gui()
    --JANELA PRINCIPAL
    x,y,w,h = fl.screen_xywh()
    JANELA = fl.double_window(1300,600,"Lua Notebook")
    JANELA:color(fl.DARK3)
    --JANELA:fullscreen()

    --INTERFACE
    fl.label(370, 5, 595, 30,"Tabalho 1");
    fl.round_clock(1230, 5, 35, 30);
    local scroll = fl.scroll(0, 40, 1360, 665);
    scroll:color(fl.DARK3);
    for i=1, 10 do
        scroll:add(fl.input(60, 70+(i*100), 1115, 50));
        scroll:add(fl.button(1195, 130+(i*100), 90, 25, "Run"));
        scroll:add(fl.input(60, 130+(i*100), 1115, 25, "stdout"));
    end
end

Gui();
JANELA:done()
JANELA:show()


print(runtime.run_code(runtime.str_to_function(
    "function b()\
        print('ok');\
        return 0;\
    end"
    )
));

return fl:run()