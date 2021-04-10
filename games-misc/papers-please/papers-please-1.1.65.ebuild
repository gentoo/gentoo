# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper

DESCRIPTION="A Dystopian Document Thriller"
HOMEPAGE="http://papersplea.se"
SRC_URI="papers-please_${PV}_i386.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="PAPERS-PLEASE"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="fetch bindist"

QA_PREBUILT="opt/${PN}/*"

RDEPEND="
	amd64? (
		>=x11-libs/libX11-1.6.2[abi_x86_32]
		>=x11-libs/libXau-1.0.7-r1[abi_x86_32]
		>=x11-libs/libXdmcp-1.1.1-r1[abi_x86_32]
		>=x11-libs/libXext-1.3.2[abi_x86_32]
		>=x11-libs/libXxf86vm-1.1.3[abi_x86_32]
		>=x11-libs/libdrm-2.4.46[abi_x86_32]
		>=x11-libs/libxcb-1.9.1[abi_x86_32]
		>=virtual/opengl-7.0-r1[abi_x86_32]
	)
	x86? (
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXxf86vm
		x11-libs/libdrm
		x11-libs/libxcb
		virtual/opengl
	)"

pkg_nofetch() {
	einfo
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your DISTDIR directory."
	einfo
}

src_prepare() {
	default

	rm -v launch.sh LICENSE || die
	mv README "${T}"/README || die
}

src_install() {
	local dir=/opt/${PN}

	insinto ${dir}
	doins -r *
	fperms +x ${dir}/PapersPlease

	make_wrapper ${PN} "./PapersPlease" "${dir}" "${dir}"
	make_desktop_entry ${PN} "Papers, Please"

	dodoc "${T}"/README
}
