local runtime = {};

function runtime.str_to_function(str)
    local aux = string.find(str,")");
    if(string.find(str,"function") and aux) then
        str = string.sub(str,aux+1,#str-3);
        print(str)
    end
    str = string.gsub(str,"print","io.stdout:write");
    return load(str);
end

function runtime.run_code(code)
    io.stdout = io.open('stdout.temp', 'w+');
    if(type(code) == "nil") then --Error in code
        io.stdout:close()
        return nil;
    end
    local aux = code();
    if(type(aux) == "nil") then
        io.stdout:close()
        return true;
    end
    io.stdout:close()
    return aux;
end

return runtime;