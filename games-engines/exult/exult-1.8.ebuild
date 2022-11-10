# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Ultima 7 game engine that runs on modern operating systems"
HOMEPAGE="https://exult.sourceforge.net/"
SRC_URI="mirror://sourceforge/exult/exult-all-versions/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="alsa fluidsynth timidity tools"

RDEPEND="
	games-misc/exult-sound
	media-libs/libpng:=
	media-libs/libsdl2[X,joystick,sound,video]
	media-libs/libvorbis
	sys-libs/zlib:=
	alsa? ( media-libs/alsa-lib )
	fluidsynth? ( media-sound/fluidsynth:= )
	timidity? ( media-sound/timidity++ )"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local econfargs=(
		--docdir="${EPREFIX}"/usr/share/${PF}/html
		--with-desktopdir="${EPREFIX}"/usr/share/applications
		--with-icondir="${EPREFIX}"/usr/share/pixmaps
		$(use_enable alsa)
		$(use_enable fluidsynth)
		$(use_enable timidity timidity-midi)
		$(use_enable tools)
		$(use_enable tools compiler)
		$(use_enable tools mods)
		--enable-zip-support
	)

	econf "${econfargs[@]}"
}

pkg_postinst() {
	elog "You *must* have the original Ultima7 The Black Gate and/or"
	elog "The Serpent Isle installed."
	elog "See documentation in ${EROOT}/usr/share/doc/${PF} for information."
}
