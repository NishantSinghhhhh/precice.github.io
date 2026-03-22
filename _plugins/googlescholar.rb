# Attribution: Jonathan Chang
# https://jonathanchang.org/blog/easily-showcase-your-google-scholar-metrics-in-jekyll

require 'open-uri'
require 'nokogiri'

module Jekyll
  class ScholarStats < Generator
    # IDs for preCICE v1 and v2 papers on Google Scholar
    CITATION_ID_V2 = '17974677460269868025,12004404035922881061'.freeze
    CITATION_ID_V1 = '5053469347483527186'.freeze
    SCHOLAR_URL = 'https://scholar.google.com/scholar?hl=en&cites='.freeze

    def generate(site)
      site.data['scholar'] = {
        'v2_citations' => fetch_citations(CITATION_ID_V2),
        'v1_citations' => fetch_citations(CITATION_ID_V1)
      }
    end

    private

    def fetch_citations(citation_id)
      url = SCHOLAR_URL + citation_id
      doc = Nokogiri::HTML(URI.parse(url).open(
        'User-Agent' => 'Mozilla/5.0 (compatible; Jekyll build)'
      ))
      # Search for string saying 'About 123 results (0,03 sec)'
      # Split and take second value '123'
      count = doc.css('#gs_ab_md .gs_ab_mdw').text.split[1]
      count ? count.gsub(',', '').to_i : nil
    rescue => e
      Jekyll.logger.warn "Fetching citation data failed with: #{e.message}"
      nil
    end
  end
end

# Usage in jekyll:
# {{ site.data.scholar.v2_citations }}
# {{ site.data.scholar.v1_citations }}