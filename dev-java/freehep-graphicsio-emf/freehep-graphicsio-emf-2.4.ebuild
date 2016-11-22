# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="freehep-vectorgraphics"
MY_P="${MY_PN}-${PV}"
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-pkg-simple

DESCRIPTION="High Energy Physics Java library - FreeHEP Enhanced Metafile Format Driver"
HOMEPAGE="http://java.freehep.org/"
SRC_URI="https://github.com/freehep/${MY_PN}/archive/${MY_P}.tar.gz"
LICENSE="Apache-2.0 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="~dev-java/freehep-graphics2d-${PV}:${SLOT}
	~dev-java/freehep-graphicsbase-${PV}:${SLOT}
	~dev-java/freehep-graphicsio-${PV}:${SLOT}
	dev-java/freehep-io:0"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.7
	test? (
		~dev-java/freehep-graphicsio-tests-${PV}:${SLOT}
		dev-java/junit:4
	)"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.7"

S="${WORKDIR}/${MY_PN}-${MY_P}/${PN}"
JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="freehep-graphics2d,freehep-graphicsbase,freehep-graphicsio,freehep-io"

java_prepare() {
	epatch "${FILESDIR}"/github-30.patch
}

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres ${PN}.jar src/main/resources
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_register-optional-dependency freehep-graphicsio-svg
	java-pkg_dolauncher emf2svg --main org.freehep.graphicsio.emf.EMF2SVG
}

src_test() {
	local DIR=src/test/java
	local CP="${DIR}:${PN}.jar:$(java-pkg_getjars junit-4,freehep-graphicsio-tests,${JAVA_GENTOO_CLASSPATH})"

	ejavac -cp "${CP}" -d ${DIR} $(find ${DIR} -name "*.java")
	ejunit4 -classpath "${CP}" org.freehep.graphicsio.emf.test.EMFTestSuite
}
