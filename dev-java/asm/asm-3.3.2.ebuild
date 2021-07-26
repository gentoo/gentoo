# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="source test"
MAVEN_ID="org.ow2.asm:asm:3.3.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Bytecode manipulation framework for Java"
HOMEPAGE="https://asm.ow2.io"
MY_P="ASM_${PV//./_}"
SRC_URI="https://gitlab.ow2.org/asm/asm/-/archive/${MY_P}/asm-${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~x64-macos"

# See https://gitlab.ow2.org/asm/asm/-/tree/390a3ba575031f80f526c585c864324b42ee62a7/test
#
# grep 'does not exist' /var/tmp/portage/dev-java/asm-3.3.2/temp/build.log | cut -d':' -f4 | sort | uniq
# package gnu.bytecode does not exist
# package gnu.bytecode.Type does not exist
# package org.mozilla.classfile does not exist

DEPEND=">=virtual/jdk-1.8
	test? (
		dev-java/aspectj:0
		dev-java/bcel:0
		dev-java/cojen:0
		dev-java/janino:0
		dev-java/javassist:3
		dev-java/jclasslib:0
		dev-java/junit:4
	)"
RDEPEND=">=virtual/jre-1.8"

S="${WORKDIR}/asm-${MY_P}"

JAVA_SRC_DIR="src"
JAVA_RESOURCE_DIRS="resources"

# those bundled jar files needed for testing seem not available from anywhere else
JAVA_GENTOO_CLASSPATH_EXTRA="test/lib/jbet3-R1.jar:test/lib/jiapi.jar:test/lib/csg-bytecode.jar:test/lib/serp-1.14.2.jar"
JAVA_TEST_GENTOO_CLASSPATH="aspectj,bcel,cojen,javassist-3,jclasslib,janino,junit-4"
JAVA_TEST_SRC_DIR="test"

src_prepare() {
	default
	cp -r "${JAVA_SRC_DIR}"/* "${JAVA_RESOURCE_DIRS}" || die
	find "${JAVA_RESOURCE_DIRS}" -type f -name '*.java' -exec rm -rf {} + || die
}
