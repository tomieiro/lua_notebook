local runtime = require "runtime"
print(runtime.run_code(runtime.str_to_function(
    "function b()\
        print('ok');\
        return 2;\
    end"
    )
));