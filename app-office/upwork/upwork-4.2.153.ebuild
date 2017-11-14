# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rpm eutils pax-utils

# Binary only distribution
QA_PREBUILT="*"

DESCRIPTION="Project collaboration and tracking software for upwork.com"
HOMEPAGE="https://www.upwork.com/"
SRC_URI="
	amd64? ( https://updates-desktopapp.upwork.com/binaries/v4_2_153_0_tkzkho5lhz15j08q/upwork_x86_64.rpm -> ${P}_x86_64.rpm )
	x86? ( https://updates-desktopapp.upwork.com/binaries/v4_2_153_0_tkzkho5lhz15j08q/upwork_i386.rpm -> ${P}_i386.rpm )
"
LICENSE="ODESK"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}

DEPEND="dev-util/patchelf"
RDEPEND="
	dev-libs/libgcrypt:11
	gnome-base/gconf
	media-libs/alsa-lib
	net-print/cups
	sys-libs/libcap
	x11-libs/gtk+:2
	x11-libs/gtkglext
"

PATCHES=( "${FILESDIR}/${PN}-desktop.patch" )

src_install() {
	pax-mark m usr/share/upwork/upwork

	dobin usr/bin/upwork

	patchelf --set-rpath /usr/share/upwork usr/share/upwork/upwork
	dolib usr/share/upwork/libcef.so
	rm usr/share/upwork/libcef.so

	insinto /usr/share
	doins -r usr/share/upwork
	fperms 0755 /usr/share/upwork/upwork

	domenu usr/share/applications/upwork.desktop
	doicon usr/share/pixmaps/upwork.png
}
