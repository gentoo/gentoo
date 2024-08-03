# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="io.pebbletemplates:pebble:${PV}"
# Missing eclass suppoert for junit-jupiter, bug #839681
# JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Templating engine for Java"
HOMEPAGE="https://pebbletemplates.io"
SRC_URI="https://github.com/PebbleTemplates/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/caffeine:0
	dev-java/jakarta-servlet-api:6
	dev-java/javax-servlet-api:2.5
	dev-java/slf4j-api:0
	dev-java/unbescape:0
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/assertj-core:3
		dev-java/byte-buddy:0
		dev-java/commons-io:1
		dev-java/junit:5
	)"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="io.pebbletemplates"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="
	assertj-core-3
	byte-buddy
	commons-io-1
	junit-4
	junit-5
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
