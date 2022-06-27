# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

MY_P="hiredis-rb-${PV}"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/hiredis_ext/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/hiredis/ext"

inherit ruby-fakegem

DESCRIPTION="Wrapper for hiredis (protocol serialization/deserialization and blocking I/O)"
HOMEPAGE="https://github.com/redis/hiredis-rb"
SRC_URI="https://github.com/redis/hiredis-rb/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND+=" =dev-libs/hiredis-0.14*:="
DEPEND+=" dev-libs/hiredis:= test? ( dev-ruby/test-unit:2 )"
DEPEND+=" virtual/pkgconfig"

RUBY_S="${MY_P}"

PATCHES=( "${FILESDIR}/${PN}-0.6.1-unvendor-hiredis.patch" )

all_ruby_prepare() {
	sed -i -e "s:/tmp/:${T}/:" test/connection_test.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}
