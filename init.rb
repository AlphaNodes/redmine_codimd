Redmine::Plugin.register :redmine_hedgedoc do
  name 'Redmine HedgeDoc'
  url 'https://github.com/alphanodes/redmine_hedgedoc'
  description 'Redmine plugin for HedgeDoc integration'
  version RedmineHedgedoc::VERSION
  author 'AlphaNodes GmbH'
  author_url 'https://alphanodes.com/'

  begin
    requires_redmine_plugin :additionals, version_or_higher: '3.0.1'
  rescue Redmine::PluginNotFound
    raise 'Please install additionals plugin (https://github.com/alphanodes/additionals)'
  end

  project_module :hedgedoc do
    permission :show_hedgedoc_pads, hedgedocs: %i[show]
    permission :import_hedgedoc_pads, hedgedocs: %i[import]
  end

  settings default: Additionals.load_settings('redmine_hedgedoc'),
           partial: 'settings/hedgedoc'

  menu :top_menu,
       :hedgedoc,
       { controller: 'hedgedocs', action: 'show', project_id: nil },
       caption: :project_module_hedgedoc,
       if: (proc do
         User.current.allowed_to?({ controller: 'hedgedocs', action: 'show' }, nil, global: true) &&
         RedmineHedgedoc.setting(:hedgedoc_in_menu) == 'top'
       end)
  menu :application_menu,
       :hedgedoc,
       { controller: 'hedgedocs', action: 'show', project_id: nil },
       caption: :project_module_hedgedoc,
       if: (proc do
         User.current.allowed_to?({ controller: 'hedgedocs', action: 'show' }, nil, global: true) &&
         RedmineHedgedoc.setting(:hedgedoc_in_menu) == 'app'
       end)
  menu :project_menu,
       :hedgedocs,
       { controller: 'hedgedocs', action: 'show' },
       caption: :project_module_hedgedoc,
       param: :project_id
end

Rails.configuration.to_prepare do
  RedmineHedgedoc.setup
end
