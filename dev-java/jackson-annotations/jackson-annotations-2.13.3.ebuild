# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/FasterXML/jackson-annotations/archive/jackson-annotations-2.13.3.tar.gz --slot 2 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jackson-annotations-2.13.3.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.fasterxml.jackson.core:jackson-annotations:2.13.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Core annotations used for value types, used by Jackson data binding package."
HOMEPAGE="https://github.com/FasterXML/jackson-annotations"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( README.md release-notes/VERSION-2.x )

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR=( "src/main/java" "src/moditect" )

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_EXCLUDES=(
	# 1) warning(junit.framework.TestSuite$1)
	# junit.framework.AssertionFailedError: No tests found in com.fasterxml.jackson.annotation.TestBase
	com.fasterxml.jackson.annotation.TestBase
)

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
