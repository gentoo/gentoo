# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem eutils

DESCRIPTION="Response JSON parser using MultiJson and FaradayMiddleware"
HOMEPAGE="https://github.com/denro/faraday_middleware-multi_json"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	dev-ruby/faraday_middleware
	dev-ruby/multi_json"

all_ruby_prepare() {
	# Remove bundler support.
	rm -f Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die

	# Avoid unneeded dependency on git.
	sed -i -e '/files/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_prepare() {
	# Make sure the test scripts use the right ruby interpreter
	#sed -i -e 's:ruby:'${RUBY}':' script/* || die
	:
}
