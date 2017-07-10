# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Library for manipulating and transforming HTML/XML documents and fragments."
HOMEPAGE="https://github.com/flavorjones/loofah"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE=""

ruby_add_rdepend ">=dev-ruby/nokogiri-1.5.9"

ruby_add_bdepend "test? ( >=dev-ruby/rr-1.1.0 >=dev-ruby/hoe-2.3.0 )"

all_ruby_prepare() {
	# Avoid test failing on different whitespace.
	sed -i -e '/test_fragment_whitewash_on_microsofty_markup/askip "gentoo"' test/integration/test_ad_hoc.rb || die

	# Fix test for new libxml2 results (fixed upstream)
	sed -i -e '348i "xhtml": "&lt;&lt;script&gt;alert(\\\"XSS\\\");//&lt;&lt;/script&gt;",' test/assets/testdata_sanitizer_tests1.dat || die
}
