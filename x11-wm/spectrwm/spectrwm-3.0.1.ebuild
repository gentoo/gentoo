# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs vcs-snapshot

DESCRIPTION="Small dynamic tiling window manager for X11"
HOMEPAGE="https://opensource.conformal.com/wiki/spectrwm"
SRC_URI="https://codeload.github.com/conformal/${PN}/tar.gz/SPECTRWM_${PV//./_} -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.6.2-Makefile.patch
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
