# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper

DESCRIPTION="High-octane action game overflowing with raw brutality"
HOMEPAGE="https://www.devolverdigital.com/games/hotline-miami"
SRC_URI="HotlineMiami_linux_1392944501.tar.gz"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bundled-libs +launcher"
RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=/opt/${PN}
QA_PREBUILT="
	${MYGAMEDIR#/}/lib/*
	${MYGAMEDIR#/}/Hotline
	${MYGAMEDIR#/}/hotline_launcher
"

# TODO: unbundle Qt5
RDEPEND="
	amd64? (
		>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
		!bundled-libs? (
			>=media-gfx/nvidia-cg-toolkit-3.1.0013-r3[abi_x86_32(-)]
			>=media-libs/libogg-1.3.0[abi_x86_32(-)]
			>=media-libs/libvorbis-1.3.3-r1[abi_x86_32(-)]
			>=media-libs/openal-1.15.1[abi_x86_32(-)]
		)
		launcher? (
			>=media-libs/freetype-2.5.0.1[abi_x86_32(-)]
			>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
			>=x11-libs/libXrandr-1.4.2[abi_x86_32(-)]
			>=x11-libs/libXrender-0.9.8[abi_x86_32(-)]
			>=x11-libs/libxcb-1.9.1[abi_x86_32(-)]
		)
	)
	x86? (
		x11-libs/libX11
		!bundled-libs? (
			media-gfx/nvidia-cg-toolkit
			media-libs/libogg
			media-libs/libvorbis
			media-libs/openal
		)
		launcher? (
			media-libs/freetype
			x11-libs/libXext
			x11-libs/libXrandr
			x11-libs/libXrender
			x11-libs/libxcb
		)
	)
"

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  https://www.humblebundle.com/store"
	einfo "and move it to your DISTDIR directory."
}

src_install() {
	insinto "${MYGAMEDIR}"
	doins HotlineMiami_GL.wad *.ogg

	exeinto "${MYGAMEDIR}"
	doexe Hotline
	use launcher && doexe hotline_launcher

	exeinto "${MYGAMEDIR}/lib"
	use launcher && doexe lib/libQt5*
	use bundled-libs && doexe libCg* libopenal*

	make_wrapper ${PN} "./Hotline" "${MYGAMEDIR}" "${MYGAMEDIR}/lib"
	make_desktop_entry ${PN}
	if use launcher ; then
		make_wrapper ${PN}-launcher "./hotline_launcher" "${MYGAMEDIR}" "${MYGAMEDIR}/lib"
		make_desktop_entry ${PN}-launcher "${PN} (launcher)"
	fi
}
