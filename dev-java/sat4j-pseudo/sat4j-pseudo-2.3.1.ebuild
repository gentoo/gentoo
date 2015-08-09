# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

MY_PN="org.sat4j.pb"
MY_PV="20111030"
BUILD_PV="2.4"

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Pseudo Boolean solvers"
HOMEPAGE="http://www.sat4j.org/"
SRC_URI="http://download.forge.objectweb.org/sat4j/sat4j-pb-v${MY_PV}.zip
	http://download.forge.objectweb.org/sat4j/build-${BUILD_PV}.xml -> ${P}-build.xml"
LICENSE="LGPL-2.1"
SLOT="2.3"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/sat4j-core:2.3"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.5"

S="${WORKDIR}"

src_unpack() {
	unpack sat4j-pb-v${MY_PV}.zip
}

java_prepare() {
	mkdir -p {core,pb}/{lib,src} || die

	# Don't complain about missing javadoc stylesheet.
	touch core/lib/stylesheet.css

	# Grab build.xml. Don't fetch from CVS. Don't build core.
	sed -e 's/depends="core"//g' \
		-e 's/depends="prepare,getsource"/depends="prepare"/g' \
		"${DISTDIR}/${P}-build.xml" > build.xml || die

	# This is the version identifier used for custom builds.
	echo 'CUSTOM' > core/src/sat4j.version || die

	# Unpack manifest.
	cd pb || die
	jar xf "${WORKDIR}/${MY_PN}.jar" META-INF || die

	# Unpack sources.
	cd src || die
	jar xf "${WORKDIR}/${MY_PN}-src.jar" || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_BUILD_TARGET="pseudo"
EANT_GENTOO_CLASSPATH="sat4j-core-2.3"
EANT_DOC_TARGET="javadoc -Dmodule=pb -Dlib=pb/lib"

src_install() {
	java-pkg_dojar dist/CUSTOM/${MY_PN}.jar
	use doc && java-pkg_dojavadoc api/pb
	use source && java-pkg_dosrc pb/src/org
}
