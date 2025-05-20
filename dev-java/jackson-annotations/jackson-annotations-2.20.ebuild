# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="Core annotations used for value types, used by Jackson data binding package."
HOMEPAGE="https://github.com/FasterXML/jackson-annotations"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-11:*" # module-info
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {README,SECURITY}.md release-notes/VERSION-2.x )

JAVA_INTERMEDIATE_JAR_NAME="com.fasterxml.jackson.annotation"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src/moditect" )
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_SRC_DIR="src/test/java"
