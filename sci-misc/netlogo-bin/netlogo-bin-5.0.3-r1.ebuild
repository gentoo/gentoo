# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils java-pkg-2

MY_PN="netlogo"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Cross-platform multi-agent programmable modeling environment"
HOMEPAGE="http://ccl.northwestern.edu/netlogo/"
SRC_URI="
	https://dev.gentoo.org/~jlec/distfiles/${PN/-bin}.gif.tar
	http://ccl.northwestern.edu/netlogo/${PV}/${MY_P}.tar.gz"
LICENSE="netlogo GPL-2 LGPL-2.1 LGPL-3 BSD Apache-2.0"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}"/${MY_P}

QA_PREBUILT="/usr/share/"${PN}"/lib/Linux-*/*.so"

src_install() {
	insinto /usr/share/"${PN}"/
	doins *.jar
	rm lib/quaqua-7.3.4.jar
	java-pkg_dojar extensions/sound/*.jar
	java-pkg_dojar extensions/profiler/*.jar
	java-pkg_dojar extensions/array/*.jar
	java-pkg_dojar extensions/gogo/*.jar
	java-pkg_dojar extensions/bitmap/*.jar
	java-pkg_dojar extensions/table/*.jar
	java-pkg_dojar extensions/gis/*.jar
	java-pkg_dojar lib/*.jar

	dohtml -r docs/*
	dodoc "docs/NetLogo User Manual.pdf" docs/shapes.nlogo
	insinto /usr/share/"${PN}"/models
	doins -r models/*

	insinto /usr/share/pixmaps
	newins  "${S}"/icon.ico netlogo.ico

	exeinto /opt/bin
	newexe "${FILESDIR}"/netlogo-5.0.3.sh netlogo
	newexe "${FILESDIR}"/netlogo-3d.sh netlogo-3d
	newexe "${FILESDIR}"/hubnet.sh hubnet
	make_desktop_entry netlogo "NetLogo" /usr/share/pixmaps/netlogo.ico
	make_desktop_entry netlogo-3d "NetLogo 2D" /usr/share/pixmaps/netlogo.ico
	make_desktop_entry hubnet "NetLogo Hubnet" /usr/share/pixmaps/netlogo.ico

	#3D Libs right now only for x86
	insinto /usr/share/"${PN}"/lib
	doins -r lib/Linux-*
}
