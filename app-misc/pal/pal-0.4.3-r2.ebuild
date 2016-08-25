# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit prefix toolchain-funcs

DESCRIPTION="Command-line calendar program"
HOMEPAGE="http://palcal.sourceforge.net/"
SRC_URI="mirror://sourceforge/palcal/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86 ~x86-interix ~amd64-linux ~x86-linux ~x86-macos"
IUSE="nls"

RDEPEND="
	>=dev-libs/glib-2.0
	nls? ( virtual/libintl )
	sys-libs/ncurses:0
	sys-libs/readline:0
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PV}-strip.patch
	"${FILESDIR}"/${PV}-ldflags.patch
	"${FILESDIR}"/${P}-pkg_config.patch
	"${FILESDIR}"/${P}-prefix.patch
	"${FILESDIR}"/fix-Wformat-security-errors.patch
)

src_prepare() {
	default

	cd src || die "failed to change to the src directory"
	eprefixify Makefile.defs input.c Makefile
	sed -i -e 's/ -o root//g' {.,convert}/Makefile || die
	tc-export PKG_CONFIG
}

src_compile() {
	cd src || die "failed to change to the src directory"
	emake CC="$(tc-getCC)" OPT="${CFLAGS}" LDOPT="${LDFLAGS}"
}

src_install() {
	dodoc ChangeLog doc/example.css

	cd src || die "failed to change to the src directory"
	emake DESTDIR="${D}" install-man install-bin install-share

	if use nls; then
		emake DESTDIR="${D}" install-mo
	fi
}
