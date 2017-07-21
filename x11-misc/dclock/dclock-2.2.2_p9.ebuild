# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic toolchain-funcs

DESCRIPTION="Digital clock for the X window system"
HOMEPAGE="http://packages.qa.debian.org/d/dclock.html"
SRC_URI="
	mirror://debian/pool/main/d/${PN}/${PN}_${PV/_p*/}.orig.tar.gz
	mirror://debian/pool/main/d/${PN}/${PN}_${PV/_p/-}.debian.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="xft"

RDEPEND="
	xft? (
		media-libs/freetype
		x11-libs/libXft
	)
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
"
DEPEND="
	${RDEPEND}
	app-text/rman
	x11-misc/imake
	xft? ( virtual/pkgconfig )
"

S=${WORKDIR}/${P/_p*/}

PATCHES=(
	"${WORKDIR}"/debian/patches
	"${FILESDIR}"/${PN}-2.2.2_p4-include.patch
)

src_configure() {
	if use xft; then
		append-cppflags \
			-DXFT_SUPPORT \
			$( $(tc-getPKG_CONFIG) --cflags freetype2)
	else
		append-cppflags -UXFT_SUPPORT
		sed -i -e '/EXTRA_LIBRARIES/s|^|#|g' Imakefile || die
	fi

	xmkmf || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	default
	emake DESTDIR="${D}" install.man

	insinto /usr/share/sounds
	doins sounds/*

	insinto /usr/share/X11/app-defaults
	newins Dclock.ad DClock
}
