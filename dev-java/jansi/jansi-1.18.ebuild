# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.fusesource.jansi:jansi:1.18"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A library that allows you to use ANSI escape sequences in your console output"
HOMEPAGE="https://fusesource.github.io/jansi/"
SRC_URI="https://github.com/fusesource/${PN}/archive/${PN}-project-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/jansi-jansi-project-${PV}/jansi"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

CP_DEPEND="
	dev-java/hawtjni-runtime:0
	dev-java/jansi-native:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
