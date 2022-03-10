# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://gentoo/distfiles/4f/xerial-core-2.0.1.tar.bz2 --slot 0 --keywords "~amd64 ~x86" --ebuild xerial-core-2.0.1-r1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.xerial:xerial-core:2.0.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Core library of the Xerial project."
HOMEPAGE="https://xerial.org"
# SRC_URI="https://github.com/xerial/xerial-java/archive/refs/tags/xerial-core-${PV}.tar.gz"
# Downloading from github is broken
SRC_URI="https://dev.gentoo.org/~ercpe/distfiles/${CATEGORY}/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS=(
	"src/test/java"
	"src/test/resources"
)

src_test() {
	# 1) listResoucesInJAR(org.xerial.util.FileResourceTest)
	# java.lang.AssertionError: at least one resource must be found in org.junit.runner
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if [[ "${vm_version}" != "1.8" ]] ; then
		JAVA_TEST_EXCLUDES+=( "org.xerial.util.FileResourceTest" )
	fi
	java-pkg-simple_src_test
}
