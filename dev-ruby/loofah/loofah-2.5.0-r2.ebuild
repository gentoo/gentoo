# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="loofah.gemspec"

inherit ruby-fakegem

DESCRIPTION="Library for manipulating and transforming HTML/XML documents and fragments."
HOMEPAGE="https://github.com/flavorjones/loofah"
SRC_URI="https://github.com/flavorjones/loofah/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux"
IUSE=""

ruby_add_rdepend "=dev-ruby/crass-1.0* >=dev-ruby/crass-1.0.2 >=dev-ruby/nokogiri-1.5.9"

ruby_add_bdepend "test? ( >=dev-ruby/rr-1.1.0 )"

all_ruby_prepare() {
	# Fix version in gemspec
	sed -i -e '/s.version/ s/".*"/"'${PV}'"/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid unneeded development dependencies
	sed -i -e '/concourse/I s:^:#:' Rakefile || die

	# Avoid test failing on different whitespace.
	sed -i -e '/test_fragment_whitewash_on_microsofty_markup/askip "gentoo"' test/integration/test_ad_hoc.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test -e 'Dir["test/**/test_*.rb"].each{|f| require f}' || die
}
