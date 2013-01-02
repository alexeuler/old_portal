# -*- coding: utf-8 -*-
module ApplicationHelper
  def tabs(number_selected,name_link_hash,optional_html="")
    html=""
    html+="<tr>\n"
    html+="<td>\n"
    html+="<ul class='tabs'>\n"

    name_link_hash.each_with_index do |(name, link),i|
      html+="<li id='"+i.to_s+"'>\n"
      class_name='tabs_button'
      class_name+=' selected' if number_selected==i
      text=('<span>'+name+'</span>').html_safe
      html+=link_to text, link, :class=>class_name
      html+="</li>\n"
    end
    html+=optional_html
    html+="</ul>\n"            
    html+="</td>\n"
    html+="</tr>\n"
    html.html_safe
  end


  def typeahead(num, data, lambda, init=nil, classes=nil, name=nil)
    html='<input type="text" data-min-length="0" data-provide="typeahead" data-items='+num.to_s
    refined=data.map {|item| lambda.call(item)}
    html+=" data-source='"+refined.to_s+"'"
    html+=" value='"+init+"'" unless init.nil?
    html+=" class="+classes unless classes.nil?
    html+=" name="+name unless name.nil?
    html+='>'
    html.html_safe
  end

  def admin?
    false
    if user_signed_in? then
      if current_user.admin? then
        true
      end
    end
  end

 
end

