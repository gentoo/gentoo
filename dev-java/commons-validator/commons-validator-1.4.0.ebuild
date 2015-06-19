# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-validator/commons-validator-1.4.0.ebuild,v 1.5 2014/04/20 11:35:15 ago Exp $

EAPI="5"

JAVA_PKG_IUSE="examples source test" # doc

inherit java-pkg-2 java-ant-2

MY_P=${P}-src

DESCRIPTION="Commons component to validate user input, or data input"
HOMEPAGE="http://commons.apache.org/validator/"
SRC_URI="mirror://apache/commons/validator/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"

RDEPEND=">=virtual/jre-1.4
	>=dev-java/commons-digester-1.6:0
	>=dev-java/commons-collections-3.1:0
	>=dev-java/commons-logging-1.0.4:0
	dev-java/commons-beanutils:1.7"

DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/junit:0 )
	${RDEPEND}"

S="${WORKDIR}/${MY_P}"

java_prepare() {
	epatch "${FILESDIR}"/validator-1.4.build.xml.patch

	JAVA_ANT_CLASSPATH_TAGS="javac java" java-ant_rewrite-classpath

	echo "commons-digester.jar=$(java-pkg_getjars commons-digester)" >> build.properties
	echo "commons-beanutils.jar=$(java-pkg_getjars commons-beanutils-1.7)" >> build.properties
	echo "commons-logging.jar=$(java-pkg_getjar commons-logging commons-logging.jar)" >> build.properties
	echo "commons-collections.jar=$(java-pkg_getjars commons-collections)" >> build.properties
}

EANT_JAVA_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="commons-beanutils-1.7,commons-collections"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},commons-digester,commons-logging,junit"

EANT_BUILD_TARGET="compile"
EANT_EXTRA_ARGS="-Dskip.download=true"

src_compile() {
	java-pkg-2_src_compile
	jar -cf ${PN}.jar -C target/classes/ . || die "Could not create jar."

	if use test ; then
		eant compile.tests ${EANT_EXTRA_ARGS} -Dgentoo.classpath="$(java-pkg_getjars --build-only --with-dependencies ${EANT_TEST_GENTOO_CLASSPATH})"
		jar -cf ${PN}-test.jar -C target/tests/ . || die "Could not create test jar."
	fi
}

# Missing test suite org.apache.commons.validator.ValidatorTestSuite; therefore, tests can't be ran.
# See https://issues.apache.org/jira/browse/VALIDATOR-323 for a bug report about this.
RESTRICT="test"

src_test() {
	echo "junit.jar=$(java-pkg_getjars junit)" >> build.properties
	eant test ${EANT_EXTRA_ARGS} -Dgentoo.classpath="$(java-pkg_getjars --build-only --with-dependencies ${EANT_TEST_GENTOO_CLASSPATH}):${PN}.jar:${PN}-test.jar"
}

src_install() {
	java-pkg_dojar ${PN}.jar

	dodoc NOTICE.txt RELEASE-NOTES.txt

	# Docs are no longer generated, as they have commented them out;
	# probably on purpose, since this is the start of a new branch.
	# use doc && java-pkg_dojavadoc dist/docs/apidocs
	use examples && java-pkg_doexamples src/example
	use source && java-pkg_dosrc src/main/java/*
}
