# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2 eutils

DESCRIPTION="A online Java-based dictionary"
HOMEPAGE="http://jdictionary.sourceforge.net/"
SRC_URI="mirror://sourceforge/jdictionary/jdictionary-${PV/./_}.zip"

IUSE=""
SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 ppc x86"

RDEPEND=">=virtual/jre-1.3"
DEPEND=">=virtual/jdk-1.3
		app-arch/unzip"
S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	mkdir compiled

	jar xf ${PN}.jar || die "failed to unpack jar"
	cp -r resources compiled
}

src_compile() {
	ejavac -classpath . $(find . -name \*.java) -d compiled || die "failed to build"
	jar cf ${PN}.jar -C compiled . || die "failed to make jar"
}

src_install() {
	java-pkg_dojar ${PN}.jar

	java-pkg_dolauncher ${PN} --main info.jdictionary.JDictionary
	make_desktop_entry ${PN} JDictionary
}
