control 'demosrv_basic' do

    srv_def_addr = "#{input('DS_IP_ADDR')}:#{input('DS_DEF_PORT')}"
    srv_custom_addr = "#{input('DS_IP_ADDR')}:#{input('DS_CUSTOM_PORT')}"

    describe http("http://#{srv_def_addr}") do
        its('status') { should cmp 200 }
        its('body') { should match %r`<h1 .*>#{input('DS_DEF_MSG')}</h1>` }
    end

    describe http("http://#{srv_custom_addr}") do
    its('status') { should cmp 200 }
    its('body') { should match %r`<h1 .*>#{input('DS_CUSTOM_MSG')}</h1>` }
end

end