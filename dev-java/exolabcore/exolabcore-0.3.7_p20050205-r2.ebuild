# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=1
WANT_ANT_TASKS="dev-java/exolabtools:0"
JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2

MY_DATE="${PV##*_p}"
MY_PV="${PV%%_p*}"
MY_P="${PN}-${MY_DATE}"

DESCRIPTION="Exolab Build Tools"
HOMEPAGE="http://openjms.cvs.sourceforge.net/openjms/exolabcore/"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="Exolab"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

COMMON_DEP="
	dev-java/cdegroot-db
	dev-java/commons-logging"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	java-virtuals/jdk-with-com-sun
	${COMMON_DEP}
	dev-java/exolabtools
	test? (
		dev-java/jakarta-oro:2.0
		dev-java/commons-cli
		dev-java/log4j
		=dev-java/junit-3.8*
	)"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}

	cd "${S}/src"
	epatch "${FILESDIR}/${P}-buildfile.patch"
	epatch "${FILESDIR}/0.3.7_p20050205-r1-tests-junit.patch"

	cd "${S}/lib"
	java-pkg_jar-from cdegroot-db-1
	java-pkg_jar-from commons-logging
}

src_compile() {
	cd "${S}/src"
	java-pkg-2_src_compile
}

src_test() {
	cd "${S}/lib"
	java-pkg_jar-from junit
	java-pkg_jar-from commons-cli-1
	java-pkg_jar-from log4j
	java-pkg_jar-from jakarta-oro-2.0

	cd "${S}/src"
	eant tests
	cd ..
	local deps
	deps="junit,commons-cli-1,log4j,cdegroot-db-1,commons-logging,jakarta-oro-2.0"
	java -cp "build/classes:build/tests:$(java-pkg_getjars ${deps})" \
		org.exolab.core.test.CoreTestSuite -execute || die "Tests failed"
}

src_install() {
	java-pkg_newjar dist/${PN}-${MY_PV}.jar ${PN}.jar

	use doc && java-pkg_dojavadoc build/doc/javadoc
	use source && java-pkg_dosrc src/main/*
}
