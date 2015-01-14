function read_query(packet)
    if string.byte(packet) == proxy.COM_QUERY then
        local file = io.open("/var/log/mysql_proxy/queries.log", "a")
        file:write(string.sub(packet, 2) .. "\n")
        file:close()
        print(string.sub(packet, 2))
    end
end