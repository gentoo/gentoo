# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A collection of tasks (and at one point maybe types and other tools) for Apache Ant"
HOMEPAGE="http://ant-contrib.sourceforge.net/"
SRC_URI="mirror://sourceforge/ant-contrib/${PN}-${PV/_beta/b}-src.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~x86-fbsd"
IUSE=""

#	test? ( dev-java/ant-junit dev-java/ant-testutil )
RDEPEND=">=virtual/jre-1.4
	>=dev-java/bcel-5.1
	>=dev-java/xerces-2.7
	>=dev-java/ant-core-1.7.0"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/tests-visibility.patch"
	cd "${S}/lib"
	java-pkg_jar-from ant-core ant.jar
	java-pkg_jar-from bcel bcel.jar bcel-5.1.jar
	java-pkg_jar-from xerces-2
}

EANT_EXTRA_ARGS="-Dversion=${PV} -Ddep.available=true"
EANT_DOC_TARGET="docs"

# The tests fail to find bcel and fail
RESTRICT="test"

src_test() {
	cd test/lib || die
	java-pkg_jar-from junit junit.jar junit-3.8.1.jar
	java-pkg_jar-from ant-testutil
	cd "${S}"
	local testutil=$(java-pkg_getjars ant-testutil)
	EANT_TEST_EXTRA_ARGS="-Dtestutil.jar.location=${testutil}" \
		java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar build/lib/${PN}.jar

	java-pkg_register-ant-task
	dodoc README.txt || die
	use doc && java-pkg_dojavadoc build/docs/api
	use source && java-pkg_dosrc src/net
	java-pkg_dohtml -r manual
}
