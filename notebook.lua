local runtime = require "runtime"

package.cpath = "/usr/local/lib/lua/5.3/?.so;" .. package.cpath;
local fl = require "moonfltk";

local itens_count = 1
local offset = 120;
local offset_scroll;

function UpdateGui()
    scroll:redraw();
    window:redraw();
end

function RunCallback(_, args)
    local widget = args[2];
    local command = args[1]:value();
    local response = runtime.run_code(runtime.str_to_function(command));
    --Colocar um assert
    if(string.find(command,"print")) then
        widget:textcolor(fl.YELLOW);
        local file = io.open("stdout.temp","r+");
        local buffer = file:read("*a");
        widget:value(buffer);
        file:close();
    elseif(not(type(response) == "nil" or type(response) == "boolean")) then
        widget:textcolor(fl.GREEN);
        widget:value(response);
    elseif(type(response) == "boolean") then
        widget:textcolor(fl.MAGENTA);
        widget:value("OK!");
    else
        widget:value("error");
        widget:textcolor(fl.RED);
    end
end

function Item()
    itens_count = itens_count + 1;
    group = fl.group(1255, 80+(offset*itens_count)-offset_scroll, 1100, 50);
    comments = fl.input(30, 80+(offset*itens_count)-offset_scroll, 1100, 50); --Comentarios group_n = 1
    group:add(comments);
    code = fl.input(30, 130+(offset*itens_count)-offset_scroll, 1100, 25); --Codigo group_n = 2
    group:add(code);
    output = fl.output(30, 130+(offset*itens_count)+25-offset_scroll, 1100, 25); --Saida group_n = 3
    output:color(fl.DARK_BLUE);
    output:textfont(fl.BOLD);
    group:add(output);
    runButton = fl.button(1150, 130+(offset*itens_count)-offset_scroll, 90, 25, "Run"); --Botao group_n = 4
    runButton:callback(RunCallback,{group:child(2),group:child(3)});
    group:add(runButton);
    scroll:add(comments); scroll:add(code); scroll:add(output); scroll:add(runButton);
    UpdateGui();
    offset_scroll = scroll:yposition()+250;
end

function Gui()
    local x,y,w,h = fl.screen_xywh()
    itens_count = 1;
    offset_scroll = 250
    window = fl.double_window(1300,600,"Lua Notebook")
    window:color(fl.DARK3)
    --window:fullscreen()
    fl.round_clock(1230, 5, 35, 30);
    scroll = fl.scroll(20, 40, 1250, 500);
    scroll:color(fl.DARK3);
    scroll:callback(UpdateGui);
    scroll:box("gtk up box");
    window:add(scroll);
    plusButton = fl.button((w/2)-100, h-200, 90, 25, "+");
    plusButton:callback(Item);
    window:add(plusButton)
end

Gui();
window:done()
window:show()
return fl:run()