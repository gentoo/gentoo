# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils qt4-r2

DESCRIPTION="Utility to create and demux TS and M2TS files"
HOMEPAGE="http://forum.doom9.org/showthread.php?t=168539"
SRC_URI="https://drive.google.com/uc?export=download&id=0B0VmPcEZTp8NekJxLUVJRWMwejQ -> ${P}.tar.gz
	http://gentoo.sbriesen.de/distfiles/tsmuxer-icon.png"
LICENSE="SmartLabs"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="qt4"

QA_FLAGS_IGNORED="opt/${PN}/bin/tsMuxeR opt/${PN}/bin/tsMuxerGUI"

DEPEND="|| (
	>=app-arch/upx-ucl-3.01[lzma]
	>=app-arch/upx-bin-3.01
)"
RDEPEND="
	>=media-libs/freetype-2.5.0.1:2[abi_x86_32(-)]
	qt4? (
		>=dev-libs/glib-2.34.3:2[abi_x86_32(-)]
		>=dev-qt/qtcore-4.8.5-r1:4[abi_x86_32(-)]
		>=dev-qt/qtgui-4.8.5-r2:4[abi_x86_32(-)]
		>=media-libs/fontconfig-2.10.92[abi_x86_32(-)]
		>=media-libs/libpng-1.2.51:1.2[abi_x86_32(-)]
		>=sys-libs/zlib-1.2.8-r1[abi_x86_32(-)]
		>=x11-libs/libICE-1.0.8-r1[abi_x86_32(-)]
		>=x11-libs/libSM-1.2.1-r1[abi_x86_32(-)]
		>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
		>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
		>=x11-libs/libXrender-0.9.8[abi_x86_32(-)]
	)
"

S="${WORKDIR}"

src_prepare() {
	upx -d tsMuxeR tsMuxerGUI || die
}

src_install() {
	dodir /opt/bin
	exeinto /opt/${PN}/bin

	doexe tsMuxeR
	dosym ../${PN}/bin/tsMuxeR /opt/bin/tsMuxeR

	if use qt4; then
		doexe tsMuxerGUI
		dosym ../${PN}/bin/tsMuxerGUI /opt/bin/tsMuxerGUI
		newicon "${DISTDIR}/${PN}-icon.png" "${PN}.png"
		make_desktop_entry tsMuxerGUI "tsMuxeR GUI" "${PN}" "Qt;AudioVideo;Video"
	fi
}
