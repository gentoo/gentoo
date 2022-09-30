# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Set window title and icon name for an X11 terminal window"
HOMEPAGE="https://kinzler.com/me/xtitle/"
SRC_URI="https://kinzler.com/me/xtitle/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="
	sys-devel/gcc
	>=x11-misc/imake-1.0.8-r1"

HTML_DOCS=( xtitle.html )

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf || die
}

src_install() {
	default

	newman "${PN}.man" "${PN}.1"
	einstalldocs
}
