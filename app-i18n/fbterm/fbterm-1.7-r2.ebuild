# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="Fast terminal emulator for the Linux framebuffer"
HOMEPAGE="https://code.google.com/p/fbterm"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN}/${P}.0.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="caps gpm video_cards_vesa"

RDEPEND="media-libs/fontconfig
	media-libs/freetype:2
	caps? ( sys-libs/libcap )
	gpm? ( sys-libs/gpm )
	video_cards_vesa? ( dev-libs/libx86 )"
DEPEND="${RDEPEND}
	sys-libs/ncurses
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-gcc6.patch )

src_prepare() {
	sed -i "s|tic|tic -o '\$(DESTDIR)\$(datadir)/terminfo'|" terminfo/Makefile.am

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

	if use caps; then
		setcap "cap_sys_tty_config+ep" "${ED}"/usr/bin/${PN}
	else
		fperms u+s /usr/bin/${PN}
	fi
}

pkg_postinst() {
	elog "${PN} won't work with vga16fb. You have to use other native"
	elog "framebuffer drivers or vesa driver."
	elog "See ${EPREFIX}/usr/share/doc/${P}/README for details."
	elog
	elog "To use ${PN}, ensure you are in video group."
}
