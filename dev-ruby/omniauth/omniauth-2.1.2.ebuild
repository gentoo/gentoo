# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A generalized Rack framework for multiple-provider authentication"
HOMEPAGE="https://github.com/omniauth/omniauth"
SRC_URI="https://github.com/omniauth/omniauth/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE="doc test"

ruby_add_rdepend "
	>=dev-ruby/rack-2.2.3
	dev-ruby/rack-protection
	>=dev-ruby/hashie-3.4.6:*"
ruby_add_bdepend "doc? ( dev-ruby/yard )
	test? ( dev-ruby/rack-test dev-ruby/rack:2.2 dev-ruby/rack-protection:3 )"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' \
		Rakefile ${PN}.gemspec || die "sed failed"
	sed -e '/RUBY_VERSION/,/^end/ s:^:#: ; /freeze/ s:^:#:' \
		-e '2igem "rack", "<3"; gem "rack-protection", "~> 3.0"' \
		-e '/simplecov/,/^end/ s:^:#:' \
		-i spec/helper.rb || die "sed failed"
	# maruku fails, resorting to default markdown implementation
	sed -i -e '/maruku/d' .yardopts || die "sed failed"

	sed -i -e '/s.files/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}

all_ruby_compile() {
	all_fakegem_compile

	if use doc ; then
		yard || die "yard failed"
	fi
}
