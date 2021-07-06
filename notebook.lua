local runtime = require "runtime"

package.cpath = "/usr/local/lib/lua/5.3/?.so;" .. package.cpath;
local fl = require "moonfltk";

function RunCallback(_, args)
    local widget = args[2];
    local command = args[1]:value();
    local response = runtime.run_code(runtime.str_to_function(command));
    --Colocar um assert
    if(string.find(command,"print")) then
        widget:textcolor(fl.YELLOW);
        local file = io.open("stdout.temp","r+");
        local buffer = file:read("*a");
        print(buffer)
        widget:value(buffer);
        file:close();
    elseif(not(type(response) == "nil" or type(response) == "boolean")) then
        widget:textcolor(fl.GREEN);
        widget:value(response);
    else
        widget:value("error");
        widget:textcolor(fl.RED);
    end

end

function Gui()
    x,y,w,h = fl.screen_xywh()
    window = fl.double_window(1300,600,"Lua Notebook")
    window:color(fl.DARK3)
    --window:fullscreen()
    fl.round_clock(1230, 5, 35, 30);
    local scroll = fl.scroll(0, 40, 1360, 665);
    scroll:color(fl.DARK3);
    local comments, code, runButton, output;
    local group;
    local count;
    count =120;
    group = fl.group(1255, 80+count, 1115, 50);
    comments = fl.input(60, 80+count, 1115, 50); --Comentarios group_n = 1
    group:add(comments);
    code = fl.input(60, 130+count, 1115, 25); --Codigo group_n = 2
    group:add(code);
    output = fl.output(60, 130+count+25, 1115, 25); --Saida group_n = 3
    output:color(fl.DARK2);
    group:add(output);
    runButton = fl.button(1195, 130+count, 90, 25, "Run"); --Botao group_n = 4
    runButton:callback(RunCallback,{group:child(2),group:child(3)});
    group:add(runButton);
    scroll:add(comments); scroll:add(code); scroll:add(output); scroll:add(runButton);
end

Gui();
window:done()
window:show()
return fl:run()