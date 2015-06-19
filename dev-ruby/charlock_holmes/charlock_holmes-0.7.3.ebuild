# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/charlock_holmes/charlock_holmes-0.7.3.ebuild,v 1.3 2015/03/20 13:33:02 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Character encoding detecting library for Ruby using ICU"
HOMEPAGE="http://github.com/brianmario/charlock_holmes"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "test? (
	dev-ruby/minitest )"

CDEPEND="dev-libs/icu:=
		sys-libs/zlib"
DEPEND+=" ${CDEPEND}"
RDEPEND+=" ${CDEPEND}"

all_ruby_prepare() {
	sed -i -e '/bundler/d' test/helper.rb || die

	# Avoid dependency on rake-compiler
	sed -i -e '/rake-compiler/,$ s:^:#:' Rakefile || die
}

each_ruby_configure() {
	${RUBY} -Cext/${PN} extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/${PN}
	cp ext/${PN}/${PN}$(get_modname) lib/${PN}/ || die
}

each_ruby_test() {
	${RUBY} -Ilib test/*.rb || die
}
