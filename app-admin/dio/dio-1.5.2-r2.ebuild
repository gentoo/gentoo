# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A device I/O monitoring tool"
HOMEPAGE="https://github.com/donaldmcintosh/dio"
SRC_URI="https://github.com/donaldmcintosh/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/src"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( "README" "../README.md" )
HTML_DOCS=( "../site/www.diodio.org/." )

src_prepare() {
	default

	# Include the 'tinfo' lib, if sys-libs/ncurses is compiled with USE="tinfo"
	sed -e "s:-lcurses:$($(tc-getPKG_CONFIG) --libs ncurses):" -i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin dio
	doman dio.1
	einstalldocs
}
