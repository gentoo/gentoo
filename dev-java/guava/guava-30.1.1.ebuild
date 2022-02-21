# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://codeload.github.com/google/guava/tar.gz/refs/tags/v30.1.1 --slot 0 --keywords "" --ebuild guava-30.1.1.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
#JAVA_TESTING_FRAMEWORKS="junit-5"
MAVEN_ID="com.google.guava:guava:${PV}-jre"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A collection of Google's core Java libraries"
HOMEPAGE="https://github.com/google/guava"
SRC_URI="https://codeload.github.com/google/guava/tar.gz/v${PV} -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# com.google.code.findbugs:jsr305:3.0.2 -> !!!groupId-not-found!!!
# com.google.errorprone:error_prone_annotations:2.5.1 -> >=dev-java/error-prone-annotations-2.7.1:0
# com.google.guava:failureaccess:1.0.1 -> >=dev-java/failureaccess-30.1.1:0
# com.google.guava:listenablefuture:9999.0-empty-to-avoid-conflict-with-guava -> !!!artifactId-not-found!!!
# com.google.j2objc:j2objc-annotations:1.3 -> !!!groupId-not-found!!!
# org.checkerframework:checker-qual:3.8.0 -> >=dev-java/checker-framework-qual-3.14.0:0

CDEPEND="
	>=dev-java/error-prone-annotations-2.7.1:0
	>=dev-java/failureaccess-30.1.1:0
	dev-java/jsr305:0
"

DEPEND="
	>=dev-java/checker-framework-qual-3.14.0:0
	dev-java/j2objc-annotations:0
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND=">=virtual/jre-1.8:*
	${CDEPEND}
"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="error-prone-annotations,failureaccess,jsr305"

src_configure() {
	JAVA_GENTOO_CLASSPATH_EXTRA="$(java-pkg_getjars --build-only checker-framework-qual,j2objc-annotations)"
}

JAVA_SRC_DIR="${PN}/src"

JAVA_TEST_SRC_DIR="${PN}-tests/"
