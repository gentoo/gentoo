# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix toolchain-funcs

DESCRIPTION="Command-line calendar program"
HOMEPAGE="https://palcal.sourceforge.net/"
SRC_URI="mirror://sourceforge/palcal/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86 ~amd64-linux ~x86-linux"
IUSE="nls"

RDEPEND="
	>=dev-libs/glib-2.0
	sys-libs/ncurses:0
	sys-libs/readline:0
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

RESTRICT="test" # Has no tests to run

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
	emake -C src CC="$(tc-getCC)" OPT="${CFLAGS}" LDOPT="${LDFLAGS}"
}

src_install() {
	dodoc ChangeLog doc/example.css
	newman pal.1.template ${PN}.1

	emake -C src DESTDIR="${D}" install-bin install-share

	if use nls; then
		emake DESTDIR="${D}" install-mo
	fi
}
