# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 eutils

DESCRIPTION="A online Java-based dictionary"
HOMEPAGE="http://jdictionary.sourceforge.net/"
SRC_URI="mirror://sourceforge/jdictionary/jdictionary-${PV/./_}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.5"
DEPEND="
	>=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}/${PN}"

java_prepare() {
	mkdir compiled || die
	unpack ./${PN}.jar || die
	cp -r resources compiled || die

	find \( -name '*.jar' -o -name '*.class' \) -exec rm {} + || die
}

src_compile() {
	ejavac -classpath . -encoding ISO-8859-1 $(find . -name \*.java) -d compiled || die
	jar cf ${PN}.jar -C compiled . || die
}

src_install() {
	java-pkg_dojar ${PN}.jar

	java-pkg_dolauncher ${PN} --main info.jdictionary.JDictionary
	make_desktop_entry ${PN} JDictionary
}
