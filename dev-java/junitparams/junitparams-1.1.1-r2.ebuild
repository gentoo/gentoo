# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="pl.pragmatists:JUnitParams:1.1.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Better parameterised tests for JUnit"
HOMEPAGE="https://github.com/Pragmatists/JUnitParams"
SRC_URI="https://github.com/Pragmatists/JUnitParams/archive/JUnitParams-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/JUnitParams-JUnitParams-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

CP_DEPEND="dev-java/junit:4"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		dev-java/assertj-core:3
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

PATCHES=( "${FILESDIR}"/junitparams-1.1.1-test.patch )

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="assertj-core-3"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

JAVA_TEST_EXCLUDES=(
	# java.lang.RuntimeException: Could not find method: paramsForSuperclassMethod so no params were used.
	"junitparams.SuperclassTest"
)

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}
