# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/java-wakeonlan/java-wakeonlan-1.0.0-r2.ebuild,v 1.2 2015/05/31 18:48:39 zlogene Exp $

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A wakeonlan commandline tool and Java library"
SRC_URI="http://www.moldaner.de/wakeonlan/download/wakeonlan-${PV}.zip"
HOMEPAGE="http://www.moldaner.de/wakeonlan/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="test"

CDEPEND="dev-java/jsap:0
	dev-java/junit:4"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	test? (
		dev-java/ant-junit:0
	)
	${CDEPEND}"

S=${WORKDIR}/wakeonlan-${PV}

EANT_GENTOO_CLASSPATH="jsap"
EANT_BUILD_TARGET="deploy"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

src_unpack() {
	unpack ${A}
}

java_prepare() {
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.xml.patch
	find -name "*.jar" | xargs rm -v
	java-ant_rewrite-classpath
}

EANT_TEST_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"
EANT_TEST_TARGET="test"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar deploy/wakeonlan.jar
	java-pkg_dolauncher ${PN} --main wol.WakeOnLan
	dodoc doc/README
	use doc && java-pkg_dojavadoc deploy/doc/javadoc
	use source && java-pkg_dosrc src/wol
}
