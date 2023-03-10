# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="info.picocli:picocli:4.6.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java command line parser with both an annotations API and a programmatic API"
HOMEPAGE="https://picocli.info"
SRC_URI="https://github.com/remkop/${PN}/archive/v${PV}.tar.gz -> ${P}-sources.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86"

# package org.junit.contrib.java.lang.system does not exist
# the project is here: https://github.com/stefanbirkner/system-rules
RESTRICT="test"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

DOCS=( LICENSE README.md RELEASE-NOTES.md )

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS=(
	"src/test/resources"
)

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
