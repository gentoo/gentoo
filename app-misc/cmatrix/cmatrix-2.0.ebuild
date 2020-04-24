# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools font

DESCRIPTION="An ncurses based app to show a scrolling screen from the Matrix"
HOMEPAGE="https://github.com/abishekvashok/cmatrix"
SRC_URI="https://github.com/abishekvashok/${PN}/archive/v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="X"

DEPEND="
	X? ( >=x11-apps/mkfontscale-1.2.0 )
	sys-libs/ncurses:0="

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PV}/0001-autotools-use-usr-share-fonts-misc-as-fonts-director.patch
	"${FILESDIR}"/${PV}/0002-autotools-respect-DESTDIR-when-installing.patch
	"${FILESDIR}"/${PV}/0003-autotools-correct-with-out-fonts.patch
	"${FILESDIR}"/${PV}/0004-autotools-ensure-DESTDIR-usr-share-consolefonts-exis.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with X fonts)
}

src_install() {
	default
}

pkg_postinst() {
	if use X; then
		if [[ -d "${ROOT}"usr/share/fonts/misc ]] ; then
			einfo ">>> Running mkfontdir on ${ROOT}usr/share/fonts/misc"
			mkfontdir "${ROOT}"usr/share/fonts/misc
		fi
		font_pkg_postinst
	fi
}

pkg_postrm() {
	use X && font_pkg_postrm
}
