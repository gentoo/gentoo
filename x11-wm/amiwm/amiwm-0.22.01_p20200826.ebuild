# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

COMMIT="8b8c956a904fa73edb02d4dc6d45bc0358bff3b3"
DESCRIPTION="Amiga Workbench inspired window manager for Xorg"
HOMEPAGE="https://github.com/redsPL/amiwm"
SRC_URI="https://github.com/chewi/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="amiwm"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

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
