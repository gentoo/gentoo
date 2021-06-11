# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper

USELESS_ID="1370288626"
DESCRIPTION="Fast paced action sidescroller set in a sci-fi environment"
HOMEPAGE="http://intrusion2.com"
SRC_URI="intrusion2-${USELESS_ID}-bin"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch"

MYGAMEDIR=opt/${PN}
QA_PREBUILT="${MYGAMEDIR#/}"/${PN}

COMMON_DEPEND="
	>=dev-libs/glib-2.34.3:2[abi_x86_32(-)]
	>=dev-libs/atk-2.10.0[abi_x86_32(-)]
	>=media-libs/gst-plugins-base-0.10.36[abi_x86_32(-)]
	>=media-libs/gstreamer-0.10.36-r2[abi_x86_32(-)]
	>=media-libs/fontconfig-2.10.92[abi_x86_32(-)]
	>=media-libs/freetype-2.5.0.1[abi_x86_32(-)]
	>=x11-libs/gdk-pixbuf-2.30.7[abi_x86_32(-)]
	>=x11-libs/gtk+-2.24.23:2[abi_x86_32(-)]
	>=x11-libs/pango-1.36.3[abi_x86_32(-)]
	>=x11-libs/libSM-1.2.1-r1[abi_x86_32(-)]
	>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
	>=x11-libs/libXinerama-1.1.3[abi_x86_32(-)]
	>=x11-libs/libXtst-1.2.1-r1[abi_x86_32(-)]
"

RDEPEND="
	amd64? (
		${COMMON_DEPEND}
	)
	x86? (
		${COMMON_DEPEND//\[abi_x86_32(-)\]/}
	)
"

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your DISTFILES directory."
	einfo
}

src_unpack() { :; }

src_install() {
	exeinto "/${MYGAMEDIR}"
	newexe "${DISTDIR}"/${SRC_URI} ${PN}

	make_wrapper ${PN} "${MYGAMEDIR}"/${PN}
	make_desktop_entry ${PN}
}
