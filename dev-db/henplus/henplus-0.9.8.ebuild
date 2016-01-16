# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 eutils java-ant-2

DESCRIPTION="Java-based multisession SQL shell for databases with JDBC support"
HOMEPAGE="http://henplus.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND="dev-java/commons-cli:1
	dev-java/libreadline-java:0"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEPEND}"

java_prepare() {
	epatch "${FILESDIR}/0.9.8-build.xml.patch"
	rm -v lib/*.jar lib/*/*.jar || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="commons-cli-1,libreadline-java"

src_install () {
	java-pkg_dojar "build/${PN}.jar"

	java-pkg_dolauncher ${PN} -pre "${FILESDIR}/${PN}.pre" \
		--main henplus.HenPlus

	dodoc README || die
	dohtml doc/HenPlus.html || die
	use doc && java-pkg_dojavadoc javadoc/api

	use source && java-pkg_dosrc "src/${PN}"
}
