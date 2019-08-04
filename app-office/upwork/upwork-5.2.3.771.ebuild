# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils rpm

# Binary only distribution
QA_PREBUILT="*"

DESCRIPTION="Project collaboration and tracking software for upwork.com"
HOMEPAGE="https://www.upwork.com/"
SRC_URI="
	amd64? ( https://updates-desktopapp.upwork.com/binaries/v5_2_3_771_okk32anbjc976nah/upwork-5.2.3.771-1fc24.x86_64.rpm -> ${P}_x86_64.rpm )
	x86? ( https://updates-desktopapp.upwork.com/binaries/v5_2_3_771_okk32anbjc976nah/upwork-5.2.3.771-1fc24.i386.rpm -> ${P}_i386.rpm )
"
LICENSE="ODESK"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}
PATCHES=( "${FILESDIR}/${PN}-desktop-r1.patch" )

DEPEND="dev-util/patchelf"
RDEPEND="
	dev-libs/expat
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf
	media-libs/alsa-lib
	media-libs/freetype
	sys-apps/dbus
	sys-libs/libcap
	x11-libs/gtk+:2[cups]
	x11-libs/gtkglext
"

src_install() {
	pax-mark m usr/share/upwork/upwork

	dobin usr/bin/upwork

	patchelf --set-rpath /usr/share/upwork usr/share/upwork/upwork

	insinto /usr/share
	doins -r usr/share/upwork
	fperms 0755 /usr/share/upwork/upwork

	domenu usr/share/applications/upwork.desktop
	doicon usr/share/pixmaps/upwork.png
}
