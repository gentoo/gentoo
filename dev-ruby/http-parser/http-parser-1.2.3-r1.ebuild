# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A super fast http parser for ruby"
HOMEPAGE="https://github.com/cotag/http-parser"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND+=" >=net-libs/http-parser-2.8.1"
RDEPEND+=" >=net-libs/http-parser-2.8.1"

ruby_add_bdepend "dev-ruby/ffi-compiler"

each_ruby_compile() {
	${RUBY} -C ext -S rake || die
	mv ext/*/libhttp-parser-ext.so lib/http-parser/ || die
}

each_ruby_install() {
	each_fakegem_install
	ruby_fakegem_extensions_installed
}
