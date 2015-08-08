# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit rpm eutils versionator

MY_PV=$(replace_version_separator 2 '-' )
MY_P="$PN-${MY_PV}"
DESCRIPTION="MolSoft LCC ICM Browser"
SRC_URI="${MY_P}.i386.rpm"
HOMEPAGE="http://www.molsoft.com/icm_browser.html"

LICENSE="MolSoft"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="fetch"

RDEPEND="!sci-chemistry/icm
	virtual/libstdc++:3.3
	>=app-arch/bzip2-1.0.6-r4[abi_x86_32(-)]
	>=media-libs/freetype-2.5.0.1[abi_x86_32(-)]
	media-libs/libmng[abi_x86_32(-)]
	>=media-libs/mesa-9.1.6[osmesa,abi_x86_32(-)]
	>=media-libs/tiff-3.9.7-r1:3[abi_x86_32(-)]
	>=sys-apps/keyutils-1.5.9-r1[abi_x86_32(-)]
	virtual/jpeg:62[abi_x86_32(-)]
	virtual/krb5[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libICE[abi_x86_32(-)]
	x11-libs/libSM[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXau[abi_x86_32(-)]
	x11-libs/libXdamage[abi_x86_32(-)]
	x11-libs/libXdmcp[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libXfixes[abi_x86_32(-)]
	x11-libs/libXmu[abi_x86_32(-)]
	x11-libs/libXrender[abi_x86_32(-)]
	x11-libs/libXt[abi_x86_32(-)]
	x11-libs/libXxf86vm[abi_x86_32(-)]
	x11-libs/libdrm[abi_x86_32(-)]
	x11-libs/libxcb[abi_x86_32(-)]
"
DEPEND=""

S="${WORKDIR}/usr/${PN}-pro-${MY_PV}"

pkg_nofetch() {
	einfo "Please download ${SRC_URI} from "
	einfo "${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
}

src_unpack() {
	rpm_src_unpack
}

src_install () {
	instdir=/opt/icm-browser
	dodir "${instdir}"
	dodir "${instdir}/licenses"
	cp -pPR * "${D}/${instdir}"
	doenvd "${FILESDIR}/90icm-browser"
	exeinto ${instdir}
	doexe "${S}/icmbrowserpro"
	doexe "${S}/lmhostid"
	doexe "${S}/txdoc"
	dosym "${instdir}/icmbrowserpro"  /opt/bin/icmbrowserpro
	dosym "${instdir}/txdoc"  /opt/bin/txdoc
	dosym "${instdir}/lmhostid"  /opt/bin/lmhostid
	# make desktop entry
	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry "icmbrowserpro -g" "ICM Browser" ${PN} Chemistry
}

pkg_postinst () {
	einfo
	einfo "Documentation can be found in ${instdir}/man/"
	einfo
	einfo "If you want to upgrade free version of browser to pro version"
	einfo "you should purchaise license from ${HOMEPAGE} and place it to"
	einfo "${instdir}/licenses"
	einfo
}
