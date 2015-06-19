# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-betwixt/commons-betwixt-0.8.ebuild,v 1.8 2012/06/20 07:29:38 sera Exp $

EAPI=2
JAVA_PKG_IUSE="doc test source"

inherit java-pkg-2 eutils java-ant-2

DESCRIPTION="Introspective Bean to XML mapper"

LICENSE="Apache-2.0"
SLOT="0.7"
KEYWORDS="amd64 ppc x86"
IUSE=""

COMMON_DEP="
	dev-java/commons-collections:0
	>=dev-java/commons-logging-1.0.2:0
	dev-java/commons-beanutils:1.7
	>=dev-java/commons-digester-1.6:0"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}
	test? (
		dev-java/ant-junit:0
		>=dev-java/xerces-2.7:2
	)"

S="${WORKDIR}/${P}-src/"

JAVA_ANT_ENCODING="ISO-8859-1"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_IGNORE_SYSTEM_CLASSES="true"
EANT_GENTOO_CLASSPATH="commons-beanutils-1.7,commons-collections,commons-digester,commons-logging"
EANT_BUILD_TARGET="init jar"

java_prepare() {
	epatch "${FILESDIR}/${PN}-0.8-test-dtd.patch"
}

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},xerces-2"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${PN}*.jar ${PN}.jar

	dodoc RELEASE-NOTES.txt README.txt || die
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
