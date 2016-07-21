# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An embedded compiler for run-time compilation purposes"
HOMEPAGE="http://janino.net/"
SRC_URI="http://janino.net/download/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

CDEPEND="dev-java/ant-core:0
	dev-java/unkrig-nullanalysis:0"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"

S="${WORKDIR}/${P}"
JAVA_SRC_DIR="src"
JAVA_GENTOO_CLASSPATH="ant-core,unkrig-nullanalysis"

java_prepare() {
	unzip "${S}"/janino-src.zip -d ${JAVA_SRC_DIR} && \
	unzip "${S}"/commons-compiler-src.zip -d ${JAVA_SRC_DIR} || die
	find -iname '*.jar' -delete || die

	mkdir -p target/classes && \
		mv src/org.codehaus.commons.compiler.properties target/classes || die

	mkdir examples || die
	mv src/org/codehaus/commons/compiler/samples/* examples/ || die
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples examples/
}
