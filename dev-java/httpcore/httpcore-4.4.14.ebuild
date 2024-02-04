# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.httpcomponents:httpcore:4.4.14"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache HttpComponents Core (blocking I/O)"
HOMEPAGE="https://hc.apache.org/httpcomponents-core-ga"
SRC_URI="mirror://apache/httpcomponents/httpcore/source/httpcomponents-core-${PV}-src.tar.gz"
S="${WORKDIR}/httpcore"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*
	test? (
		dev-java/commons-logging:0
		dev-java/mockito:0
	)"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{LICENSE,NOTICE,README,RELEASE_NOTES}.txt )

JAVA_SRC_DIR=(
	"src/main/java"
	"src/main/java-deprecated"
)
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="commons-logging,junit-4,mockito"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_test() {
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge "17" ; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.net=ALL-UNNAMED )
		eapply "${FILESDIR}/httpcore-4.4.14-skipTests.patch"
	fi
	java-pkg-simple_src_test
}
