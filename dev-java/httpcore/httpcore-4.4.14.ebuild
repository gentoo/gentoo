# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom httpcore/pom.xml --download-uri https://mirror.netcologne.de/apache.org//httpcomponents/httpcore/source/httpcomponents-core-4.4.14-src.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild httpcomponents-core-4.4.14.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.httpcomponents:httpcore:4.4.14"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache HttpComponents Core (blocking I/O)"
HOMEPAGE="https://hc.apache.org/httpcomponents-core-ga"
SRC_URI="mirror://apache/httpcomponents/httpcore/source/httpcomponents-core-${PV}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Compile dependencies
# POM: httpcore/pom.xml
# test? commons-logging:commons-logging:1.2 -> >=dev-java/commons-logging-1.2:0
# test? junit:junit:4.12 -> >=dev-java/junit-4.13.2:4
# test? org.mockito:mockito-core:1.10.19 -> >=dev-java/mockito-1.9.5:0

DEPEND=">=virtual/jdk-1.8:*
	test? (
		dev-java/commons-logging:0
		dev-java/mockito:0
	)"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{LICENSE,NOTICE,README,RELEASE_NOTES}.txt )

S="${WORKDIR}/httpcore"

JAVA_SRC_DIR=(
	"src/main/java"
	"src/main/java-deprecated"
)
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="commons-logging,junit-4,mockito"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_install() {
	default
	java-pkg-simple_src_install
}
