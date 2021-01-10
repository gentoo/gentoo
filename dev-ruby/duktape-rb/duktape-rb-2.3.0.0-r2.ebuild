# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_GEMSPEC="duktape.gemspec"
RUBY_FAKEGEM_NAME="duktape"

inherit ruby-fakegem

MY_PN=${PN/-/\.}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Ruby bindings to the Duktape JavaScript interpeter"
HOMEPAGE="https://github.com/judofyr/duktape.rb"
SRC_URI="https://github.com/judofyr/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ppc"

COMMON_DEPEND="dev-lang/duktape:="
DEPEND+="${COMMON_DEPEND}"
RDEPEND+="${COMMON_DEPEND}"

ruby_add_bdepend "
	dev-ruby/pkg-config
	dev-ruby/rake-compiler
	dev-ruby/sdoc
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.0.0_duktape-2.5.0-tests.patch
	"${FILESDIR}"/${PN}-2.3.0.0_use-system-duktape.patch
)

RUBY_S=${MY_P}

all_ruby_prepare() {
	rm ext/duktape/duktape.{c,h} ext/duktape/duk_config.h || die "Failed to remove bundled duktape"
}

each_ruby_configure() {
	${RUBY} -C ext/duktape extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	${RUBY} -S rake compile
}
