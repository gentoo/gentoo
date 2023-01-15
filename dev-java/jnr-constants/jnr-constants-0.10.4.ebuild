# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.github.jnr:jnr-constants:0.10.4"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A set of platform constants (e.g. errno values)"
HOMEPAGE="https://github.com/jnr/jnr-constants"
SRC_URI="https://github.com/jnr/${PN}/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${PN}-${P}"

JAVA_AUTOMATIC_MODULE_NAME="org.jnrproject.constants"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
