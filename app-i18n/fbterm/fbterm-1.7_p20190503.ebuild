# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools fcaps toolchain-funcs vcs-snapshot

EGIT_COMMIT="ccea326dd73f4d6b6442fde7ba7c2be9cd35c6df"

DESCRIPTION="Fast terminal emulator for the Linux framebuffer"
HOMEPAGE="https://github.com/gjedeer/fbterm"
SRC_URI="https://github.com/gjedeer/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="gpm video_cards_vesa"

BDEPEND="virtual/pkgconfig"
DEPEND="media-libs/fontconfig
	media-libs/freetype:2
	>=sys-libs/ncurses-6.1
	gpm? ( sys-libs/gpm )
	video_cards_vesa? ( dev-libs/libx86 )"
RDEPEND="${DEPEND}"

FILECAPS=(
	cap_sys_tty_config+ep usr/bin/${PN}
)

src_prepare() {
	# bug #648472
	sed -i "s/terminfo//" Makefile.am || die "Can't remove terminfo"

	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable gpm) \
		$(use_enable video_cards_vesa vesa)
}

src_compile() {
	emake AR="$(tc-getAR)"
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
