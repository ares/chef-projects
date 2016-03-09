def project_path(name)
  "#{node[:projects][:root]}/#{name}"
end

def project_attributes(name, options = {})
  [
    name.tr('-', '_'),
    {
      :gem_name => name,
      :name => name,
      :path => project_path(name),
    }.merge(options)
  ]
end
