# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/Pragmatists/JUnitParams/archive/refs/tags/JUnitParams-1.1.1.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild junitparams-1.1.1.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="pl.pragmatists:JUnitParams:1.1.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Better parameterised tests for JUnit"
HOMEPAGE="https://github.com/Pragmatists/JUnitParams"
SRC_URI="https://github.com/Pragmatists/JUnitParams/archive/refs/tags/JUnitParams-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 ~x86"

# Common dependencies
# POM: pom.xml
# junit:junit:4.12 -> >=dev-java/junit-4.12:4

CP_DEPEND="dev-java/junit:4"

# Compile dependencies
# POM: pom.xml
# test? org.assertj:assertj-core:1.7.1 -> >=dev-java/assertj-core-2.3.0:2

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		dev-java/assertj-core:3
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

PATCHES=(
	"${FILESDIR}"/junitparams-1.1.1-test.patch
)

S="${WORKDIR}/JUnitParams-JUnitParams-${PV}"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="assertj-core-3"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

JAVA_TEST_EXCLUDES=(
	# java.lang.RuntimeException: Could not find method: paramsForSuperclassMethod so no params were used.
	"junitparams.SuperclassTest"
)

src_prepare() {
	default
}
