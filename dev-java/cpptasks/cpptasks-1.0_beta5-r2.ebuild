# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Ant-tasks to compile various source languages and produce executables"
HOMEPAGE="http://ant-contrib.sourceforge.net/"
SRC_URI="mirror://sourceforge/ant-contrib/ant-contrib/${P/_/-}/${P/_beta/b}.tar.gz"
S="${WORKDIR}/${P/_beta/b}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 ~x86"

CP_DEPEND="
	>=dev-java/ant-1.10.14:0
	dev-java/xerces:2
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		>=dev-java/ant-1.10.14:0[junit]
		dev-java/junit:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS="javac javadoc"

EANT_BUILD_TARGET="jars"
EANT_TEST_TARGET="run-tests -Djunit-available=true"
EANT_DOC_TARGET="javadocs -Dbuild.javadocs=build/api"

src_prepare() {
	java-pkg_clean
	use test && eapply "${FILESDIR}/${P}-test-classpath.patch"
	java-pkg-2_src_prepare
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar target/lib/${PN}.jar

	java-pkg_register-ant-task

	dodoc NOTICE
	use doc && java-pkg_dojavadoc build/api
	use examples && java-pkg_doexamples src/samples/*
	use source && java-pkg_dosrc src/main/java/*
}
