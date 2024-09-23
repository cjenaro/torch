module PagesHelper
  def render_page_tree(pages)
    if pages
      content_tag :ul, class: 'space-y-2' do
        pages.map do |page|
          concat(content_tag(:li, class: 'pl-4') do
            concat(link_to(page.title, workspace_page_path(page.workspace, page), class: 'text-blue-600 hover:underline'))
            if page.children.any?
              concat(button_tag(type: 'button', data: { action: 'click->collapsible#toggle' }, class: 'ml-2 text-sm text-gray-600') do
                "▶"
              end)
              concat(content_tag(:div, data: { collapsible_target: 'content' }, class: 'ml-4') do
                render_page_tree(page.children)
              end)
            end
          end)
        end.join.html_safe
      end
    end
  end
end
