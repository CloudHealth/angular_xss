# Use module_eval so we crash when Haml::Helpers has not yet been loaded.
Haml::Helpers.module_eval do

  def html_escape_with_escaping_angular_expressions_haml(s)
    s = s.to_s
    if s.html_safe?
      s
    else
      html_escape_without_escaping_angular_expressions_haml(AngularXss::Escaper.escape(s)).html_safe
    end
  end

  alias_method_chain :html_escape, :escaping_angular_expressions_haml

end
