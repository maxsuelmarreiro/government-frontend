class DetailedGuidePresenter < ContentItemPresenter
  include Body
  include ContentsList
  include Metadata
  include NationalApplicability
  include Political
  include TitleAndContext

  def context
    parent["title"]
  end

  def related_guides
    links("related_guides")
  end

  def related_mainstream_content
    links("related_mainstream_content")
  end

  def image
    content_item["details"]["image"]["url"] if content_item["details"]["image"]
  end

  def document_footer
    super.tap do |m|
      m[:other][related_guides_title] = related_guides
    end
  end

private

  def related_guides_title
    I18n.t('detailed_guide.related_guides')
  end
end
