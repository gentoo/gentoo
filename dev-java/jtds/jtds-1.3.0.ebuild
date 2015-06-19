# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jtds/jtds-1.3.0.ebuild,v 1.1 2012/10/30 19:24:54 sera Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="jTDS - SQL Server and Sybase JDBC driver"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
HOMEPAGE="http://jtds.sourceforge.net"

LICENSE="LGPL-2.1"
SLOT="1.3"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Would need a running server
RESTRICT="test"

COMMON_DEPEND="
	dev-java/jcifs:1.1"
RDEPEND="${COMMON_DEPEND}
	virtual/jre:1.7"
DEPEND="${COMMON_DEPEND}
	virtual/jdk:1.7
	app-arch/unzip"

S=${WORKDIR}

java_prepare() {
	find -name '*.jar' -exec rm -v {} + || die

	epatch "${FILESDIR}"/${P}-build.xml.patch

	mkdir -p build/doc || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

EANT_GENTOO_CLASSPATH="jcifs-1.1"

src_install() {
	java-pkg_newjar build/${P}.jar

	dodoc CHANGELOG README*
	use doc && java-pkg_dojavadoc build/doc
	use source && java-pkg_dosrc "${S}"/src/main/*
}
