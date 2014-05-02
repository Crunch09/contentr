FactoryGirl.define do
  factory :paragraph, class: Contentr::HtmlParagraph do |h|
    h.body %{
        <div class="content-txt start white start">
        <h1><span style="color:#005C94">Agapedia</span> ist die von J&uuml;rgen Klinsmann 1995 gegr&uuml;ndete Stiftung, die Projekte zur F&ouml;rderung von hilfsbed&uuml;rftigen und Not leidenden Kindern aufbaut.
          Ziel aller Ma&szlig;nahmen ist es, betroffenen Kindern direkt zu helfen und gesellschaftliche Entwicklungen durch nachhaltige Projekte zu unterst&uuml;tzen. <span style="color:#005C94">ist eine Manufaktur der Menschlichkeit.</span>
        </h1>
        </div>}
    h.area_name :center_column
    h.position 0
  end

  factory :content_block_paragraph, class: Contentr::ContentBlockParagraph do |cbp|
    cbp.content_block_to_display {create(:content_block)}
    cbp.area_name :center_column
    cbp.position 0
  end
end
