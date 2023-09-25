# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

COMMIT="74a398944f9a2c543b6b176e65ed4ee2373b1d65"
DESCRIPTION="Amiga Workbench inspired window manager for Xorg"
HOMEPAGE="https://github.com/sdomi/amiwm"
SRC_URI="https://github.com/chewi/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="amiwm"
SLOT="0"
KEYWORDS="~amd64 ~m68k ~ppc ~x86"

COMMON_DEPEND="
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXext
"

RDEPEND="
	${COMMON_DEPEND}
	media-fonts/font-misc-misc[nls,X]
	x11-apps/xrdb
	x11-apps/xsetroot
"

DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default
	eautoconf
}

src_install() {
	emake install DESTDIR="${D}" STRIPFLAG=
	einstalldocs

	exeinto /etc/X11/Sessions
	newexe - ${PN} <<-EOF
		#!/bin/sh
		exec ${PN}
	EOF
}
