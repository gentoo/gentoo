# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Enlightenment DR16 epplets"
HOMEPAGE="https://www.enlightenment.org https://sourceforge.net/projects/enlightenment/"
SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2+ BSD public-domain"
SLOT="0"
IUSE="cdaudio libgtop opengl"

BDEPEND="
	virtual/pkgconfig
"
CDEPEND="
	cdaudio? ( media-libs/libcdaudio )
	libgtop? ( gnome-base/libgtop )
	opengl? ( media-libs/glu media-libs/mesa[X(+)] )
	>=media-libs/imlib2-1.2.0
	x11-libs/libX11
	x11-libs/libXext
	x11-wm/e16
"
RDEPEND="${CDEPEND}
	!x11-plugins/epplets
"
DEPEND="${CDEPEND}
	x11-base/xorg-proto
"

src_configure() {
	local myconf=(
		$(use_enable cdaudio)
		$(use_enable opengl glx)
		$(use_with libgtop)
		--disable-esd
		--disable-static
		--disable-werror
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}"/usr -name '*.la' -delete || die
}
