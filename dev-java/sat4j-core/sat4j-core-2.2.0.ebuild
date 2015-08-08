# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

MY_PN="org.${PN//-/.}"
MY_PV="20100623"
BUILD_PV="2.4"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Lightweight constraint programming with a SAT solver"
HOMEPAGE="http://www.sat4j.org/"
SRC_URI="http://download.forge.objectweb.org/sat4j/${PN}-v${MY_PV}.zip
	http://download.forge.objectweb.org/sat4j/build-${BUILD_PV}.xml -> ${P}-build.xml"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}"

src_unpack() {
	unpack ${PN}-v${MY_PV}.zip
}

java_prepare() {
	mkdir -p core/{lib,src} || die

	# Don't complain about missing javadoc stylesheet.
	touch core/lib/stylesheet.css

	# Grab build.xml. Don't fetch from CVS. Version file is gone.
	sed -e 's/depends="prepare,getsource"/depends="prepare"/g' \
		-e '/<replace/d' \
		"${DISTDIR}/${P}-build.xml" > build.xml || die

	# Unpack manifest.
	cd core || die
	jar xf "${WORKDIR}/${MY_PN}.jar" META-INF || die

	# Unpack sources.
	cd src || die
	jar xf "${WORKDIR}/${MY_PN}-src.jar" || die
}

EANT_BUILD_TARGET="core"
EANT_DOC_TARGET="javadoc -Dmodule=core -Dlib=core/lib"

src_install() {
	java-pkg_dojar dist/CUSTOM/${MY_PN}.jar
	use doc && java-pkg_dojavadoc api/core
	use source && java-pkg_dosrc core/src/org
}
