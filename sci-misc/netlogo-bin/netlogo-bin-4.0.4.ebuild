# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/netlogo-bin/netlogo-bin-4.0.4.ebuild,v 1.5 2013/01/07 01:08:51 creffett Exp $

EAPI=4

inherit eutils java-pkg-2

MY_PN="netlogo"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Cross-platform multi-agent programmable modeling environment"
HOMEPAGE="http://ccl.northwestern.edu/netlogo/"
SRC_URI="
	http://dev.gentoo.org/~jlec/distfiles/${PN/-bin}.gif.tar
	http://ccl.northwestern.edu/netlogo/${PV}/${MY_P}.tar.gz"
LICENSE="netlogo"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}"/${MY_P}

QA_PREBUILT="/usr/share/"${PN}"/lib/*.so"

src_install() {
	java-pkg_dojar *.jar
	java-pkg_dojar extensions/sound/*.jar
	java-pkg_dojar extensions/profiler/*.jar
	java-pkg_dojar extensions/array/*.jar
	java-pkg_dojar extensions/gogo/*.jar
	java-pkg_dojar extensions/sample/*.jar
	java-pkg_dojar extensions/table/*.jar
	java-pkg_dojar extensions/gis/*.jar
	java-pkg_dojar lib/*.jar

	dohtml -r docs/*
	insinto /usr/share/"${PN}"/models
	doins -r models/*

	insinto /usr/share/pixmaps
	doins  "${WORKDIR}"/netlogo.gif

	exeinto /opt/bin
	newexe "${FILESDIR}"/netlogo.sh netlogo

	make_desktop_entry netlogo "NetLogo" /usr/share/pixmaps/netlogo.gif

	#3D Libs right now only for x86
	insinto /usr/share/"${PN}"/lib
	doins lib/*.so
}
