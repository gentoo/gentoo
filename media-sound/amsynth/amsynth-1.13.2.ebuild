# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Virtual analogue synthesizer"
HOMEPAGE="https://github.com/amsynth/amsynth"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/release-${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="alsa dssi gtk jack lash lv2 nsm oss vst"

REQUIRED_USE="dssi? ( gtk ) lv2? ( gtk ) vst? ( gtk )"

BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
"
RDEPEND="
	alsa? (
		media-libs/alsa-lib:=
		media-sound/alsa-utils
	)
	dssi? (
		media-libs/dssi:=
		media-libs/liblo:=
	)
	gtk? (
		x11-libs/gtk+:2
		x11-libs/libX11
	)
	jack? ( virtual/jack )
	lash? ( media-sound/lash )
	lv2? ( media-libs/lv2 )
"
DEPEND="${RDEPEND}
	oss? ( virtual/os-headers )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.12.2-metadata.patch"
)

src_prepare() {
	default
	! use gtk && eapply "${FILESDIR}/${PN}-1.12.2-x11.patch"
}

src_configure() {
	econf \
		$(use_with alsa) \
		$(use_with dssi) \
		$(use_with gtk gui) \
		$(use_with jack) \
		$(use_with lash) \
		$(use_with lv2) \
		$(use_with nsm) \
		$(use_with oss) \
		$(use_with vst)
}
