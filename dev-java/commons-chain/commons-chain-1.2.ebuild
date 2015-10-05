# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_P="${P}-src"
DESCRIPTION="API exposing the Chain of Responsability design pattern - by the ASF"
HOMEPAGE="http://commons.apache.org/proper/commons-chain/"
SRC_URI="mirror://apache/commons/chain/source/${MY_P}.zip"

LICENSE="Apache-2.0"
SLOT="1.2"
KEYWORDS="amd64 x86"

# Too many missing imports from javax.servlet.* which causes the
# "compile-tests" target to fail compiling.
# I gave up on them after wasting nearly half a day.
RESTRICT="test"

IUSE=""

CDEPEND="dev-java/commons-digester:0
	dev-java/mojarra:2.2
	dev-java/portletapi:2.0
	dev-java/commons-logging:0
	java-virtuals/servlet-api:3.0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="
	commons-logging
	commons-digester
	portletapi-2.0
	mojarra-2.2
	servlet-api-3.0
"

EANT_BUILD_TARGET="package"
EANT_BUILD_XML="build.xml"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml
}

src_install() {
	java-pkg_newjar "${S}"/target/${P}.jar commons-chain.jar

	if use doc; then
		java-pkg_dohtml -r "${S}"/target/site/apidocs/
	fi

	if use source; then
		java-pkg_dosrc "${S}"/src/*
	fi
}
