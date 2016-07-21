# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils java-pkg-2

MY_PN="netlogo"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Cross-platform multi-agent programmable modeling environment"
HOMEPAGE="http://ccl.northwestern.edu/netlogo/"
SRC_URI="
	https://dev.gentoo.org/~jlec/distfiles/${PN/-bin}.gif.tar
	http://ccl.northwestern.edu/netlogo/${PV}/${MY_P}.tar.gz"

LICENSE="netlogo"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	app-arch/unzip
	>=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}"/${MY_P}

src_install() {
	java-pkg_dojar *.jar
	java-pkg_dojar extensions/*.jar
	java-pkg_dojar lib/*.jar

	dohtml -r docs/*
	insinto /usr/share/${PN}/models
	doins -r models/*

	insinto /usr/share/pixmaps
	doins  "${WORKDIR}"/netlogo.gif

	exeinto /opt/bin
	newexe "${FILESDIR}"/netlogo.sh netlogo

	make_desktop_entry netlogo "NetLogo" /usr/share/pixmaps/netlogo.gif
}
