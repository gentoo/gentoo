# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

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
	>=dev-ruby/brotli-0.1.8
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
	sed -i -e '/\(cane\|parallel\|rubocop\|simplecov\)/ s:^:#:' \
		-e "/addressable/ s/, '< 2.4'//" \
		-e "/rack/ s/< 2/< 2.3/" \
		-e "/rack-cache/ s/, '< 1.3'//" \
		-e "/simple_oauth/ s/, '< 0.3'//" \
		-e "/safe_yaml/ s:^:#:" \
		-e "/webmock/ s/2.3/3.0/" Gemfile || die

	# Avoid unneeded dependency on git
	sed -i -e '/git ls-files/d' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '1irequire "fileutils"' spec/spec_helper.rb || die

	# Avoid safe_yaml specs since they are broken with newer ruby versions
	# and safe_yaml is not mandatory for using faraday_middleware.
	rm -f spec/unit/parse_yaml_spec.rb || die
}

each_ruby_test() {
	${RUBY} -S bundle exec rspec-3 spec || die
}
