# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def close_button
    content_tag(:button, '×', class: :close)
  end

  # Renders OpenGraph Meta tags for the given option to help facebook parse the website.
  def render_og_metadata(options = {})
    html = ''
    options.reverse_merge({
      :site_name => 'Wheelmap.org',
      :type => 'website',
      :url => request.url
    }).reject{|key,value|
      value.blank?
    }.each{|key, value|
      if value.is_a? Array
        value.each do |element|
          html << tag(:meta, :property => "og:#{key}", :content => element) + "\n"
        end
      else
        html << tag(:meta, :property => "og:#{key}", :content => value) + "\n"
      end
    }
    html << tag(:meta, :property => "fb:app_id", :content => '289221174426029')
    html.html_safe
  end

  def render_og_locationdata(options = {})
    html = ''
    options.reject{|key,value|
      value.blank?
    }.each do |key, value|
      html << tag(:meta, :property => "place:location:#{key}", :content => value) + "\n"
    end
    html.html_safe
  end

  def link_to_participate
    if I18n.locale == :de
      link_to( t('how?'), "http://blog.wheelmap.org/mitmachen", :target => '_blank')
    else
      link_to( t('how?'), "http://blog.wheelmap.org/en/participate", :target => '_blank')
    end
  end

  def var_language
    "var language = \"#{I18n.locale.to_s.gsub(/(-[a-z]{2})/){ $1.upcase unless $1.nil?}}\""
  end

  def url_for_locale(url, locale)
    uri = URI.parse(url)
    # Ommit leading locale for default locale
    if uri.path =~ /^\/$/ # /
      uri.path = "/#{locale}/"
    elsif uri.path =~ /^\/tlh($|\/)/
      uri.path = uri.path.gsub(/^\/tlh($|\/)/, "/#{locale}/")
    elsif uri.path =~ /^\/[a-z]{2}(-[a-zA-Z]{2})?($|\/)/ #/pt-TR/
      uri.path = uri.path.gsub(/^\/\w{2}(-\w{2})?($|\/)/, "/#{locale}/")
    else
      uri.path = uri.path.gsub(/^(.+?)$/, "/#{locale}" + '\1')
    end
    # remove trailing slash
    uri.path = uri.path.gsub(/\/$/,'')
    uri
  end

  # Flash message for new layout.
  def render_flash
    html = ''
    [:notice,:error,:alert].each do |type|
      html << "<div class='notification #{type}' id='#{type}_div_id' style='display:none'><span></span></div>"
    end
    html.html_safe
  end

  # Flash message for old layout.
  def show_flash
    html = ''
    [:notice,:error,:alert].each do |type|
      html << "<div id=\"#{type}\" class=\"flash\" style=\"display:none;\"><a data=\"hide\" href=\"#\">&times;</a></div>"
    end
    html.html_safe
  end

  def community_press_url
    if I18n.locale == :de
      "http://wheelmap.org/about/presse/"
    else
      "http://wheelmap.org/en/about/press/"
    end
  end

  def community_contact_url
    if I18n.locale == :de
      "http://wheelmap.org/kontakt/"
    else
      "http://wheelmap.org/en/contact/"
    end
  end

  def community_projects_url
    if I18n.locale == :de
      "http://wheelmap.org/projekte/"
    else
      "http://wheelmap.org/en/get-engaged/"
    end
  end

  def community_imprint_url
    if I18n.locale == :de
      "http://wheelmap.org/impressum/"
    else
      "http://wheelmap.org/en/imprint/"
    end
  end

  def community_about_url
    if I18n.locale == :de
      "http://wheelmap.org/about/"
    else
      "http://wheelmap.org/en/about/"
    end
  end

  def community_newsletter_url
    if I18n.locale == :de
      "http://wheelmap.org/newsletter/"
    else
      "http://wheelmap.org/newsletter-2/"
    end
  end

  def mailme_to(email_address, name = nil, html_options = {}, &block)

    raise "mailme_to: Use native mail_to method with Rails 4.0 and later." if Rails.version.starts_with?("4.")

    email_address = ERB::Util.html_escape(email_address)

    html_options, name = name, nil if block_given?
    html_options = (html_options || {}).stringify_keys

    extras = %w{ cc bcc body subject }.map { |item|
     option = html_options.delete(item) || next
     "#{item}=#{Rack::Utils.escape_path(option)}"
    }.compact
    extras = extras.empty? ? '' : '?' + ERB::Util.html_escape(extras.join('&'))

    html_options["href"] = "mailto:#{email_address}#{extras}".html_safe

    content_tag(:a, name || email_address.html_safe, html_options, &block)
  end
end
