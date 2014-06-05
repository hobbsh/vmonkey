require_relative '../../lib/vmonkey'

instructions = "
  For the integration tests to run, you need:
    - On the machine running the specs:
      + #{ENV['VMONKEY_YML']} (see below)

    - On your vSphere system
      + A VM or Template from which VMs will be cloned (:template_path)
      + A working Folder into which cloned VMs will be placed (:working_folder)
      + An empty vApp into which cloned VMs will be placed (:vapp_path)
      + A Customization Spec which will be applied to cloned VMs (:customization_spec)

  Place the following in #{ENV['VMONKEY_YML']}
    host: host_name_or_ip_address
    user: user_name
    password: password
    insecure: true
    ssl: true
    datacenter: datacenter_name
    cluster: cluster_name
    spec:
      :template_path: /path/to/a/vm_or_template
      :working_folder: /path/to/a/folder
      :vapp_pool_path: /cluster_name/monkey_vapp
      :vapp_path: /path/to/a/vapp
      :customization_spec: name-of-a-cust-spec
  "

raise instructions unless File.exists? ENV['VMONKEY_YML']

monkey = VMonkey.connect
VM_SPEC_OPTS = monkey.opts[:spec]
raise instructions unless monkey.folder VM_SPEC_OPTS[:working_folder]
raise instructions unless monkey.vm VM_SPEC_OPTS[:template_path]
raise instructions unless monkey.vapp VM_SPEC_OPTS[:vapp_path]
raise instructions unless monkey.dc.find_pool VM_SPEC_OPTS[:vapp_pool_path]
raise instructions unless monkey.customization_spec VM_SPEC_OPTS[:customization_spec]

RSpec.configure do |config|
  config.color_enabled = true
  config.tty = true
  config.formatter = :documentation
end
