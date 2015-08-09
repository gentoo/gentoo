# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PN="netty"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Async event-driven framework for rapid development of high performance network applications"
HOMEPAGE="http://netty.io/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${MY_P}.Final.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/commons-logging:0
	dev-java/javassist:3
	dev-java/log4j:0
	dev-java/slf4j-api:0"
RDEPEND=">=virtual/jre-1.6
		${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
		${CDEPEND}"

S="${WORKDIR}/${MY_PN}-${MY_P}.Final/${PN/${MY_PN}-}"

EANT_BUILD_TARGET="package"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="commons-logging,log4j,javassist-3,slf4j-api"

# Tests fail as they might need logging to be properly set up and/or compatible.
#
# junit.framework.AssertionFailedError: expected:<[foo]> but was:<[NOP]>
# at io.netty.util.internal.logging.Slf4JLoggerFactoryTest.testCreation
RESTRICT="test"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
}

src_install() {
	java-pkg_newjar target/${MY_PN}-*.jar ${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
