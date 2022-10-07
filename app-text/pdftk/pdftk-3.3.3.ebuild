# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.gitlab.pdftk-java:pdftk-java:3.3.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A port of pdftk into java"
HOMEPAGE="https://gitlab.com/pdftk-java/pdftk"
SRC_URI="https://gitlab.com/pdftk-java/pdftk/-/archive/v${PV}/pdftk-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

CP_DEPEND="
	dev-java/bcprov:0
	dev-java/commons-lang:3.6
"

# Compile dependencies
# POM: pom.xml
# test? com.github.stefanbirkner:system-rules:1.19.0 -> !!!groupId-not-found!!!
# test? junit:junit:4.12 -> >=dev-java/junit-4.13.2:4

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		app-text/poppler[cairo]
		dev-java/system-rules:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

DOCS=( CHANGELOG.md README.md )

S="${WORKDIR}/${PN}-v${PV}"

JAVA_LAUNCHER_FILENAME="${PN}"
JAVA_MAIN_CLASS="com.gitlab.pdftk_java.pdftk"
JAVA_SRC_DIR="java"
JAVA_RESOURCE_DIRS="resources/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,system-rules"
JAVA_TEST_SRC_DIR="test"

src_prepare() {
	default
	mkdir resources || die
	cp -r {,resources/}java || die
	rm -r resources/java/com/gitlab/pdftk_java/com/lowagie/text/pdf/codec || die
	find resources/java -type f \( -name '*.java' -o -name '*.sh' \) -exec rm -rf {} + || die
}

src_test() {
	# some tests seem to need special treatment
	einfo "Runnig first test"
	JAVA_TEST_RUN_ONLY=(
		com.gitlab.pdftk_java.CatTest
		com.gitlab.pdftk_java.DataTest
		com.gitlab.pdftk_java.FormTest
		com.gitlab.pdftk_java.MultipleTest
	)
	java-pkg-simple_src_test
	einfo "Running second test"
	JAVA_TEST_RUN_ONLY=()
	JAVA_TEST_EXCLUDES=(
		com.gitlab.pdftk_java.CatTest
		com.gitlab.pdftk_java.DataTest
		com.gitlab.pdftk_java.FormTest
		com.gitlab.pdftk_java.MultipleTest
	)
	java-pkg-simple_src_test
}
