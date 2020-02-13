# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

MY_P="hiredis-rb-${PV}"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem toolchain-funcs

DESCRIPTION="Wrapper for hiredis (protocol serialization/deserialization and blocking I/O)"
HOMEPAGE="https://github.com/redis/hiredis-rb"
SRC_URI="https://github.com/redis/hiredis-rb/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND+=" >=dev-libs/hiredis-0.14:="
DEPEND+=" dev-libs/hiredis test? ( dev-ruby/test-unit:2 )"

RUBY_S="${MY_P}"

PATCHES=( "${FILESDIR}/${PN}-0.6.1-unvendor-hiredis.patch" )

all_ruby_prepare() {
	sed -i -e 's:/tmp/:'${T}'/:' test/connection_test.rb || die
}

each_ruby_configure() {
	CC=$(tc-getCC) ${RUBY} -Cext/hiredis_ext extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/hiredis_ext
	cp ext/hiredis_ext/hiredis_ext.so lib/hiredis/ext/ || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}
