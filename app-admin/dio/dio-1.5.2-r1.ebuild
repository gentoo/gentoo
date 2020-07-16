# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="A device I/O monitoring tool"
HOMEPAGE="https://github.com/donaldmcintosh/dio"
SRC_URI="https://github.com/donaldmcintosh/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 x86"
LICENSE="MIT"
SLOT="0"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}/src"

DOCS=( "README" "../README.md" )
HTML_DOCS=( "../site/www.diodio.org/." )

src_prepare() {
	# Include the 'tinfo' lib, if sys-libs/ncurses is compiled with USE="tinfo"
	if has_version -d 'sys-libs/ncurses[tinfo]'; then
		sed -e 's/lcurses/& -ltinfo/' -i Makefile || die
	fi

	default
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin dio
	doman dio.1
	einstalldocs
}
