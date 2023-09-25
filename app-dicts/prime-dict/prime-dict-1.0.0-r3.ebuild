# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31"

inherit ruby-ng

DESCRIPTION="Dictionary files for PRIME input method"
HOMEPAGE="http://taiyaki.org/prime/"
SRC_URI="https://${PN}.osdn.jp/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ppc64 ~riscv ~sparc x86"
IUSE=""

each_ruby_configure() {
	econf --with-rubydir="$(ruby_rbconfig_value 'sitelibdir')"
}

each_ruby_compile() {
	emake
}

each_ruby_install() {
	emake DESTDIR="${D}" install
}

all_ruby_install() {
	einstalldocs
}
