# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Response JSON parser using MultiJson and FaradayMiddleware"
HOMEPAGE="https://github.com/denro/faraday_middleware-multi_json"
SRC_URI="https://github.com/denro/faraday_middleware-multi_json/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	dev-ruby/faraday_middleware:*
	dev-ruby/multi_json"

all_ruby_prepare() {
	# Remove bundler support.
	rm -f Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die

	# Avoid unneeded dependency on git.
	sed -i -e '/files/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die
}
