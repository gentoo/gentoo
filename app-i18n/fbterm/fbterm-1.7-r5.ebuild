# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools fcaps

DESCRIPTION="Fast terminal emulator for the Linux framebuffer"
HOMEPAGE="https://code.google.com/p/fbterm"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN}/${P}.0.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="gpm video_cards_vesa"

RDEPEND="media-libs/fontconfig
	media-libs/freetype:2
	gpm? ( sys-libs/gpm )
	video_cards_vesa? ( dev-libs/libx86 )
	>=sys-libs/ncurses-6.1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-gcc6.patch )

FILECAPS=(
	cap_sys_tty_config+ep usr/bin/${PN}
)

src_prepare() {
	# bug #648472
	sed -i "s/terminfo//" Makefile.am

	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable gpm) \
		$(use_enable video_cards_vesa vesa)
}

src_install() {
	default

	use filecaps || fperms u+s /usr/bin/${PN}
}

pkg_postinst() {
	fcaps_pkg_postinst

	elog "${PN} won't work with vga16fb. You have to use other native"
	elog "framebuffer drivers or vesa driver."
	elog "See ${EPREFIX}/usr/share/doc/${P}/README for details."
	elog
	elog "To use ${PN}, ensure you are in video group."
}
