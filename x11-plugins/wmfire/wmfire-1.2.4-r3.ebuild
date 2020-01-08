# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Load monitoring dockapp displaying dancing flame"
HOMEPAGE="http://www.improbability.net/#wmfire"
SRC_URI="http://www.improbability.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="session"

RDEPEND="x11-libs/gtk+:2
	gnome-base/libgtop:2
	x11-libs/libX11
	x11-libs/libXext
	session? ( x11-libs/libSM
		x11-libs/libICE )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( ALL_I_GET_IS_A_GREY_BOX AUTHORS ChangeLog NEWS README )

src_prepare() {
	default
	eapply "${FILESDIR}"/${PN}-1.2.3-stringh.patch
	eapply "${FILESDIR}"/${P}-no_display.patch
	eapply "${FILESDIR}"/${P}-lastprocessor_SMP.patch
	eapply "${FILESDIR}"/${P}-inline_c99.patch
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable session)
}
