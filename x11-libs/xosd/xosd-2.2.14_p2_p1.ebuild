# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils autotools versionator

MY_PV=$(get_version_component_range 1-3)
MY_PATCH_MAJ=$(get_version_component_range 4)
MY_PATCH_MIN=$(get_version_component_range 5)

DESCRIPTION="Library for overlaying text in X-Windows X-On-Screen-Display"
HOMEPAGE="https://sourceforge.net/projects/libxosd/"
SRC_URI="mirror://debian/pool/main/x/xosd/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/x/xosd/${PN}_${MY_PV}-${MY_PATCH_MAJ/p/}.${MY_PATCH_MIN/p/}.debian.tar.xz
	http://digilander.libero.it/dgp85/gentoo/${PN}-gentoo-m4-1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86"
IUSE="static-libs xinerama"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	media-fonts/font-misc-misc"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto"

DOCS=(
	AUTHORS ChangeLog NEWS README TODO
)
S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	epatch "${WORKDIR}"/debian/patches/*.diff
	# bug #286632
	epatch "${FILESDIR}"/"${PN}"-config-incorrect-dup-filter-fix.patch

	eapply_user

	AT_M4DIR="${WORKDIR}/m4" eautoreconf
}

src_configure() {
	econf \
		$(use_enable xinerama) \
		$(use_enable static-libs static)
}
