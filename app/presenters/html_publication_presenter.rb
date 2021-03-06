class HtmlPublicationPresenter < ContentItemPresenter
  include Body
  include OrganisationBranding

  def contents?
    contents && contents != '<ol></ol>'
  end

  def contents
    content_item["details"]["headings"].try(:html_safe)
  end

  def isbn
    content_item["details"]["isbn"]
  end

  def web_isbn
    content_item["details"]["web_isbn"]
  end

  def print_meta_data_contact_address
    content_item["details"]["print_meta_data_contact_address"]
  end

  def copyright_year
    content_item["details"]["public_timestamp"].to_date.year if public_timestamp.present?
  end

  def format_sub_type
    parent["document_type"] if parent && parent["document_type"].present?
  end

  def last_changed
    timestamp = display_date(public_timestamp)

    # This assumes that a translation doesn't need the date to come beforehand.
    if content_item["details"]["first_published_version"]
      "#{I18n.t('content_item.metadata.published')} #{timestamp}"
    else
      "#{I18n.t('content_item.metadata.updated')} #{timestamp}"
    end
  end

  def organisations
    orgs = content_item["links"]["organisations"] || []
    orgs.sort_by { |o| o["title"] }
  end

  def organisation_logo(organisation)
    super.tap do |logo|
      if logo && organisations.count > 1
        logo[:organisation].delete(:image)
      end
    end
  end

  def full_path(request)
    request.base_url + request.path
  end

private

  def public_timestamp
    content_item["details"]["public_timestamp"]
  end
end
