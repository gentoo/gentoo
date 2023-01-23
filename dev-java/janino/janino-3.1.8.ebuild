# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom janino/pom.xml --download-uri https://github.com/janino-compiler/janino/archive/refs/tags/v3.1.8.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild janino-3.1.8.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.codehaus.janino:janino:3.1.8"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An embedded compiler for run-time compilation purposes"
HOMEPAGE="https://janino-compiler.github.io/janino/"
SRC_URI="https://github.com/janino-compiler/janino/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Compile dependencies
# POM: ${PN}/pom.xml
# org.apache.ant:ant:1.10.11 -> !!!suitable-mavenVersion-not-found!!!
# POM: ${PN}/pom.xml
# test? de.unkrig.jdisasm:jdisasm:1.0.6 -> !!!groupId-not-found!!!
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.2:4

DEPEND="
	>=virtual/jdk-1.8:*
	dev-java/ant-core:0
	test? (
		dev-java/jdisasm:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*"

S="${WORKDIR}/${P}/janino"

src_prepare() {
	default
	java-pkg_clean
}

src_compile() {
	JAVA_JAR_FILENAME="commons-compiler.jar"
	JAVA_SRC_DIR="../commons-compiler/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":commons-compiler.jar"
	rm -r target || die

	JAVA_CLASSPATH_EXTRA="ant-core"
	JAVA_JAR_FILENAME="janino.jar"
	JAVA_RESOURCE_DIRS="src/main/resources"
	JAVA_SRC_DIR="src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":janino.jar"
	rm -r target || die

	if use doc; then
		JAVA_SRC_DIR=(
			"../commons-compiler/src/main/java"
			"src/main/java"
		)
		JAVA_JAR_FILENAME="ignoreme.jar"
		java-pkg-simple_src_compile
	fi
}

src_test() {
	einfo "Testing commons-compiler"
	JAVA_TEST_GENTOO_CLASSPATH="junit-4"
	JAVA_TEST_RESOURCE_DIRS="../commons-compiler/src/test/resources"
	JAVA_TEST_SRC_DIR="../commons-compiler/src/test/java"
	java-pkg-simple_src_test

	einfo "Testing janino"
	JAVA_TEST_GENTOO_CLASSPATH="jdisasm,junit-4"
	JAVA_TEST_RESOURCE_DIRS="src/test/resources"
	JAVA_TEST_SRC_DIR="src/test/java"
	java-pkg-simple_src_test
}

src_install() {
	default

	java-pkg_dojar "commons-compiler.jar"
	java-pkg_dojar "janino.jar"

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	if use source; then
		java-pkg_dosrc "../commons-compiler/src/main/java/*"
		java-pkg_dosrc "src/main/java/*"
	fi
}
