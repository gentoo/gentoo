# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A generalized Rack framework for multiple-provider authentication"
HOMEPAGE="https://github.com/intridea/omniauth"
SRC_URI="https://github.com/intridea/omniauth/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_rdepend "dev-ruby/rack:*
	>=dev-ruby/hashie-1.2:* <dev-ruby/hashie-4:*"
ruby_add_bdepend "doc? ( dev-ruby/yard )
	test? ( dev-ruby/rack-test )"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' \
		Rakefile ${PN}.gemspec || die "sed failed"
	sed -i -e '/RUBY_VERSION/,/^end/ s:^:#:' spec/helper.rb || die "sed failed"
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
