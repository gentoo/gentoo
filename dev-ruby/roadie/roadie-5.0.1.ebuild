# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="yard"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Making HTML emails comfortable for the Rails rockstars"
HOMEPAGE="https://github.com/Mange/roadie"
SRC_URI="https://github.com/Mange/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/nokogiri-1.8:0
	>=dev-ruby/css_parser-1.4.5 =dev-ruby/css_parser-1*"
ruby_add_bdepend "test? ( dev-ruby/rspec-collection_matchers dev-ruby/webmock )"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
	sed -i -e 's/git ls-files/find * -type f -print/' \
		-e '/test_files/d' \
		-e '/css_parser/ s/~>/>=/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
