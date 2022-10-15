# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/qos-ch/slf4j/archive/v_1.7.36.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild slf4j-api-1.7.36.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.slf4j:slf4j-api:1.7.36"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The slf4j API"
HOMEPAGE="https://www.slf4j.org"
SRC_URI="https://github.com/qos-ch/slf4j/archive/v_${PV}.tar.gz -> slf4j-${PV}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"
BDEPEND="app-arch/zip"

DOCS=( LICENSE.txt ../README.md )

S="${WORKDIR}/slf4j-v_${PV}/${PN}"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

JAVA_TEST_EXCLUDES=(
	# java.lang.InstantiationException - not run by upstream anyway
	"org.slf4j.helpers.MultithreadedInitializationTest"
)

src_prepare() {
	default
	java-pkg_clean
}

src_compile() {
	java-pkg-simple_src_compile

	# remove org/slf4j/impl/ from the jar file
	zip -d ${PN}.jar org/slf4j/impl/\* || die "Failed to remove impl files"
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
