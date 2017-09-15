# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="yard"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Making HTML emails comfortable for the Rails rockstars"
HOMEPAGE="https://github.com/Mange/roadie"
SRC_URI="https://github.com/Mange/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/nokogiri-1.5.0
	>=dev-ruby/css_parser-1.4.5 =dev-ruby/css_parser-1.4*"
ruby_add_bdepend "test? ( dev-ruby/rspec-collection_matchers dev-ruby/webmock )"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
	sed -i -e 's/git ls-files/find . -type f -print/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
