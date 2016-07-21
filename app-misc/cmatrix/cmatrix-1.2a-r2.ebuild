# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=6

inherit autotools eutils

DESCRIPTION="An ncurses based app to show a scrolling screen from the Matrix"
HOMEPAGE="http://www.asty.org/cmatrix"
SRC_URI="http://www.asty.org/${PN}/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="X"

DEPEND="
	X? ( x11-apps/mkfontdir )
	sys-libs/ncurses:0="

RDEPEND="${DEPEND}"

CPATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	use X && CPATCHES+=( "${FILESDIR}"/${P}-fontdir.patch )
	epatch "${CPATCHES[@]}"
	eautoreconf
}

src_install() {
	dodir /usr/share/consolefonts
	dodir /usr/lib/kbd/consolefonts
	use X && dodir /usr/share/fonts/misc
	emake DESTDIR="${D}" install
}

pkg_postinst() {
	if use X; then
		if [[ -d "${ROOT}"usr/share/fonts/misc ]] ; then
			einfo ">>> Running mkfontdir on ${ROOT}usr/share/fonts/misc"
			mkfontdir "${ROOT}"usr/share/fonts/misc || die 'mkfontdir failed'
		fi
	fi
}
