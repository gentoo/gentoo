# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/netty-transport/netty-transport-4.0.21-r1.ebuild,v 1.2 2015/02/23 20:42:38 zmedico Exp $

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

CDEPEND="dev-java/${MY_PN}-buffer:0
	dev-java/${MY_PN}-common:0"

RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.7
	${CDEPEND}"

S="${WORKDIR}/${MY_PN}-${MY_P}.Final/${PN/${MY_PN}-}"

EANT_BUILD_TARGET="package"
EANT_GENTOO_CLASSPATH="${MY_PN}-buffer,${MY_PN}-common"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_ENCODING="UTF-8"

# error: package ch.qos.logback.classic does not exist
RESTRICT="test"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
}

src_install() {
	java-pkg_newjar target/${MY_PN}-*.jar ${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
