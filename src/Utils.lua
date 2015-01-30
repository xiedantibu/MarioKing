local DEBUG=true

function cclog(...)
    if(DEBUG)then
        print(string.format(...))
    end
end