# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom janino/pom.xml --download-uri https://codeload.github.com/janino-compiler/janino/tar.gz/v3.1.6 --slot 0 --keywords "~amd64" --ebuild JANjanino-3.1.6.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.codehaus.janino:janino:3.1.6"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An embedded compiler for run-time compilation purposes"
HOMEPAGE="https://janino-compiler.github.io/janino/"
SRC_URI="https://codeload.github.com/janino-compiler/janino/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ppc64 ~x86"

# Common dependencies
# POM: janino/pom.xml
# org.codehaus.janino:commons-compiler:3.1.6 -> !!!groupId-not-found!!!

# Compile dependencies
# POM: janino/pom.xml
# org.apache.ant:ant:1.10.9 -> !!!groupId-not-found!!!
# POM: janino/pom.xml
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.2:4

DEPEND="
	>=virtual/jdk-1.8:*
	dev-java/ant-core:0
"

RDEPEND="
	>=virtual/jre-1.8:*"

S="${WORKDIR}/${P}/janino"

src_prepare() {
	default
	java-pkg_clean
}

src_compile() {
	JAVA_SRC_DIR="../commons-compiler/src/main/java"
	JAVA_JAR_FILENAME="commons-compiler.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":commons-compiler.jar"
	rm -r target || die

	JAVA_CLASSPATH_EXTRA="ant-core"
	JAVA_SRC_DIR="src/main/java"
	JAVA_RESOURCE_DIRS="src/main/resources"
	JAVA_JAR_FILENAME="janino.jar"
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
	JAVA_TEST_GENTOO_CLASSPATH="junit-4"
	JAVA_TEST_SRC_DIR="../commons-compiler/src/test/java"
	JAVA_TEST_RESOURCE_DIRS="../commons-compiler/src/test/resources"
	java-pkg-simple_src_test

	JAVA_TEST_GENTOO_CLASSPATH="junit-4"
	JAVA_TEST_SRC_DIR="src/test/java"
	JAVA_TEST_RESOURCE_DIRS="src/test/resources"
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
