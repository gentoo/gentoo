# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

MY_P="${PN}-src-${PV}"
DESCRIPTION="A content repository"
HOMEPAGE="http://jakarta.apache.org/slide/index.html"
SRC_URI="http://archive.apache.org/dist/jakarta/slide/source/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4
	dev-java/commons-httpclient:3
	dev-java/jdom:1.0
	dev-java/xml-im-exporter:0"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}"

S="${WORKDIR}/${MY_P}"

JAVA_ANT_REWRITE_CLASSPATH="true"

src_prepare() {
	epatch "${FILESDIR}/${P}-gentoo.patch"
	rm -v lib/*.jar || die
	java-pkg-2_src_prepare
}

EANT_GENTOO_CLASSPATH="jdom-1.0,commons-httpclient-3,xml-im-exporter"
EANT_BUILD_TARGET="dist-clientlib"
EANT_DOC_TARGET="javadoc-clientlib"

src_install() {
	java-pkg_newjar dist/lib/${P/client/lib}.jar ${PN/client/lib}.jar

	dodoc README || die
	use doc && java-pkg_dojavadoc build/clientlib/doc/clientjavadoc
	use source && java-pkg_dosrc \
		clientlib/src/java/* \
		ant/src/java/* \
		commandline/src/java/* \
		connector/src/java/*
}
