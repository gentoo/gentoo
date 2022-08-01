# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.tngtech.junit.dataprovider:junit-dataprovider:2.9"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The common core for a TestNG like dataprovider runner for JUnit"
HOMEPAGE="https://github.com/TNG/junit-dataprovider"
SRC_URI="https://github.com/TNG/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="dev-java/findbugs-annotations:0"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	dev-java/junit:4
	test? (
		dev-java/assertj-core:3
		dev-java/mockito:4
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

DOCS=( {CODE-OF-CONDUCT,CONTRIBUTING,README,SECURITY}.md NOTICE )

S="${WORKDIR}/${PN}-${PV}/"

src_compile() {
	einfo "Compiling junit-dataprovider-core"
	JAVA_SRC_DIR="core/src/main/java"
	JAVA_JAR_FILENAME="junit-dataprovider-core.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":junit-dataprovider-core.jar"
	rm -r target || die

	einfo "Compiling junit4-dataprovider"
	JAVA_SRC_DIR="junit4/src/main/java"
	JAVA_JAR_FILENAME="juni4-dataprovider.jar"
	JAVA_CLASSPATH_EXTRA="junit-4"
	java-pkg-simple_src_compile
	rm -r target || die

	if use doc; then
		einfo "Compiling javadocs"
		JAVA_SRC_DIR=(
			"core/src/main/java"
			"junit4/src/main/java"
		)
		JAVA_JAR_FILENAME="ignoreme.jar"
		java-pkg-simple_src_compile
	fi
}

src_test() {
	einfo "Testing junit-dataprovider-core"
	JAVA_TEST_GENTOO_CLASSPATH="assertj-core-3,junit-4,mockito:4"
	JAVA_TEST_SRC_DIR="core/src/test/java"
	java-pkg-simple_src_test

	einfo "Testing junit4-dataprovider"
	JAVA_TEST_SRC_DIR="junit4/src/main/java"
	JAVA_TEST_EXCLUDES=(
		com.tngtech.java.junit.dataprovider.internal.TestGenerator
		com.tngtech.java.junit.dataprovider.internal.TestValidator
	)
	java-pkg-simple_src_test
}

src_install() {
	java-pkg_dojar "junit-dataprovider-core.jar"
	java-pkg_dojar "juni4-dataprovider.jar"

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	if use source; then
		java-pkg_dosrc "core/src/main/java/*"
		java-pkg_dosrc "junit4/src/main/java/*"
	fi
}
