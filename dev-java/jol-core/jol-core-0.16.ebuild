# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.openjdk.jol:jol-core:0.16"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN%-core}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Java Object Layout: Core"
HOMEPAGE="https://openjdk.java.net/projects/code-tools/jol/"
SRC_URI="https://github.com/openjdk/jol/archive/refs/tags/${PV}.tar.gz -> jol-${PV}.tar.gz"

LICENSE="GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/asm:4
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${MY_P}"

JAVA_SRC_DIR="${PN}/src/main/java"
JAVA_RESOURCE_DIRS=( "${PN}/src/main/resources" )

JAVA_TEST_GENTOO_CLASSPATH="junit-4,asm-4"
JAVA_TEST_SRC_DIR="${PN}/src/test"

src_install() {
	java-pkg-simple_src_install
	einstalldocs # https://bugs.gentoo.org/789582
}
