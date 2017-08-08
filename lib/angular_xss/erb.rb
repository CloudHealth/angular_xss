# Use module_eval so we crash when ERB::Util has not yet been loaded.
ERB::Util.module_eval do

  if private_method_defined? :unwrapped_html_escape # Rails 4.2+

    def unwrapped_html_escape_with_escaping_angular_expressions_erb(s)
      s = s.to_s
      if s.html_safe?
        s
      else
        unwrapped_html_escape_without_escaping_angular_expressions_erb(AngularXss::Escaper.escape(s)).html_safe
      end
    end

    alias_method_chain :unwrapped_html_escape, :escaping_angular_expressions_erb

    singleton_class.send(:remove_method, :unwrapped_html_escape)
    module_function :unwrapped_html_escape
    module_function :unwrapped_html_escape_without_escaping_angular_expressions_erb

  else # Rails < 4.2

    def html_escape_with_escaping_angular_expressions_erb(s)
      s = s.to_s
      if s.html_safe?
        s
      else
        html_escape_without_escaping_angular_expressions_erb(AngularXss::Escaper.escape(s)).html_safe
      end
    end

    alias_method_chain :html_escape, :escaping_angular_expressions_erb

    # Aliasing twice issues a warning "discarding old...". Remove first to avoid it.
    remove_method(:h)
    alias h html_escape

    module_function :h

    singleton_class.send(:remove_method, :html_escape)
    module_function :html_escape
    module_function :html_escape_without_escaping_angular_expressions_erb

  end

end
