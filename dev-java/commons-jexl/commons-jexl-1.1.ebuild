# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-jexl/commons-jexl-1.1.ebuild,v 1.7 2014/08/10 20:11:14 slyfox Exp $

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Expression language engine, can be embedded in applications and frameworks"
HOMEPAGE="http://commons.apache.org/jexl/"
SRC_URI="mirror://apache/jakarta/commons/jexl/source/${P}-src.tar.gz"

CDEPEND="dev-java/commons-logging
	=dev-java/junit-3*"

RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/ant-junit )
	${CDEPEND}"

LICENSE="Apache-2.0"
SLOT="1.0"
KEYWORDS="amd64 ppc x86"
IUSE=""

S="${WORKDIR}/${P}-src"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# https://issues.apache.org/jira/browse/JEXL-31
	epatch "${FILESDIR}/1.1-test-target.patch"

	mkdir -p target/lib && cd target/lib
	java-pkg_jar-from junit junit.jar
	java-pkg_jar-from commons-logging
}

src_test() {
	ANT_TASKS="ant-junit" eant test
}

src_install() {
	java-pkg_newjar target/${P}*.jar

	dodoc RELEASE-NOTES.txt || die

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc "${S}"/src/java/*
}
