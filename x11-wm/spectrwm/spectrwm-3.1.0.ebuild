# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib toolchain-funcs vcs-snapshot

DESCRIPTION="Small dynamic tiling window manager for X11"
HOMEPAGE="https://github.com/conformal/spectrwm"
SRC_URI="https://github.com/conformal/${PN}/archive/SPECTRWM_${PV//./_}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="x11-misc/dmenu"
DEPEND="${DEPEND}
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXrandr
	x11-libs/libXtst
	x11-libs/xcb-util
	!x11-wm/scrotwm"

S=${WORKDIR}/${P}/linux

PATCHES=( "${FILESDIR}"/${P}-Makefile.patch )

src_prepare() {
	default
	tc-export CC
}

src_compile() {
	emake PREFIX="${EROOT}usr" LIBDIR="${EROOT}usr/$(get_libdir)"
}

src_install() {
	emake PREFIX="${EROOT}usr" LIBDIR="${EROOT}usr/$(get_libdir)" DESTDIR="${D}" install

	cd "${WORKDIR}"/${P} || die

	insinto /etc
	doins ${PN}.conf
	dodoc ${PN}_*.conf {initscreen,screenshot}.sh

	make_session_desktop ${PN} ${PN}

	elog "Example keyboard config and helpful scripts can be found"
	elog "in ${ROOT}usr/share/doc/${PF}"
}
