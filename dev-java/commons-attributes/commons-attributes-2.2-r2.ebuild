# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Commons Attributes enables Java programmers to use C#/.Net-style attributes in their code"
HOMEPAGE="http://commons.apache.org/attributes/"
SRC_URI="mirror://apache/commons/attributes/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~x86"

COMMON_DEP="dev-java/ant-core:0
	dev-java/gjdoc:0
	dev-java/qdox:1.6
	dev-java/xjavadoc:0"

DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="ant-core,gjdoc,qdox-1.6"

src_compile() {
	java-pkg-2_src_compile

	# The generated build.xml is faulty.
	jar uf target/${PN}-compiler-${PV}.jar -C compiler/src/java \
		org/apache/commons/attributes/anttasks.properties || die
}

src_install() {
	java-pkg_newjar target/${PN}-api-${PV}.jar ${PN}-api.jar
	java-pkg_newjar target/${PN}-compiler-${PV}.jar ${PN}-compiler.jar

	java-pkg_register-ant-task

	dodoc NOTICE.txt
	dohtml README.html

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc api/src/java/org compiler/src/java/org
}
