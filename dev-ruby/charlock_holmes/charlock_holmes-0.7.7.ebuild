# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Character encoding detecting library for Ruby using ICU"
HOMEPAGE="https://github.com/brianmario/charlock_holmes"
SRC_URI="https://github.com/brianmario/charlock_holmes/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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
