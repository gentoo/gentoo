# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem eutils

DESCRIPTION="Various middleware for Faraday"
HOMEPAGE="https://github.com/lostisland/faraday_middleware"
SRC_URI="https://github.com/lostisland/faraday_middleware/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE="+parsexml +oauth +mashify +rashify"

ruby_add_rdepend "
	dev-ruby/faraday:1
	parsexml? ( >=dev-ruby/multi_xml-0.5.3 )
	oauth? ( >=dev-ruby/simple_oauth-0.1 )
	mashify? ( >=dev-ruby/hashie-1.2:* )
	rashify? ( >=dev-ruby/rash_alt-0.4.3 )"

# Bundler must be used because the optional dependencies have different
# version requirements that must be resolved.
ruby_add_bdepend "test? (
	dev-ruby/bundler
	dev-ruby/addressable
	>=dev-ruby/rake-12.3.3
	dev-ruby/webmock:3
	dev-ruby/json
	>=dev-ruby/multi_xml-0.5.3
	>=dev-ruby/rack-cache-1.1
	>=dev-ruby/simple_oauth-0.1
	>=dev-ruby/hashie-1.2
	>=dev-ruby/rash_alt-0.4.3 )"

all_ruby_prepare() {
	sed -i -e '/\(cane\|parallel\|simplecov\)/ s:^:#:' \
		-e '/rspec/ s/>=/~>/' \
		-e "/addressable/ s/, '< 2.4'//" \
		-e "/rack/ s/< 2/< 2.1/" \
		-e "/rack-cache/ s/, '< 1.3'//" \
		-e "/simple_oauth/ s/, '< 0.3'//" \
		-e "/webmock/ s/< 2/~> 3.0/" Gemfile || die

	# Avoid unneeded dependency on git
	sed -i -e '/git ls-files/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -S bundle exec rspec-3 spec || die
}
