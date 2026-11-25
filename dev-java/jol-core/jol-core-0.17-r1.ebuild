# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN%-core}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Java Object Layout: Core"
HOMEPAGE="https://openjdk.org/projects/code-tools/jol/"
SRC_URI="https://github.com/openjdk/jol/archive/${PV}.tar.gz -> jol-${PV}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

# Max. jdk 21, bug #977449
DEPEND="
	<virtual/jdk-25:*
	test? (
		dev-java/asm:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_RESOURCE_DIRS="${PN}/src/main/resources"
JAVA_SRC_DIR="${PN}/src/main/java"
JAVA_TEST_EXTRA_ARGS=( -Djdk.attach.allowAttachSelf )
JAVA_TEST_GENTOO_CLASSPATH="junit-4,asm"
JAVA_TEST_SRC_DIR="${PN}/src/test/java"
