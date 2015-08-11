# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="netty"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Async event-driven framework for rapid development of high performance network applications"
HOMEPAGE="http://netty.io/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${MY_P}.Final.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND="dev-java/commons-logging:0
	dev-java/javassist:3
	dev-java/log4j:0
	dev-java/slf4j-nop:0
	dev-java/slf4j-api:0"
RDEPEND=">=virtual/jre-1.6
		${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
		${CDEPEND}"

S="${WORKDIR}/${MY_PN}-${MY_P}.Final/${PN/${MY_PN}-}"

JAVA_GENTOO_CLASSPATH="
	log4j
	slf4j-api
	slf4j-nop
	javassist-3
	commons-logging"

JAVA_SRC_DIR="src/main/java"

# Tests fail as they might need logging to be properly set up and/or compatible.
#
# junit.framework.AssertionFailedError: expected:<[foo]> but was:<[NOP]>
# at io.netty.util.internal.logging.Slf4JLoggerFactoryTest.testCreation
RESTRICT="test"
