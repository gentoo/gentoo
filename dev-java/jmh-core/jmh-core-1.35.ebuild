# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.openjdk.jmh:jmh-core:1.35"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Harness for building, running, and analysing nano/micro/milli/macro benchmarks"
HOMEPAGE="https://openjdk.java.net/projects/code-tools/jmh/"
SRC_URI="https://github.com/openjdk/jmh/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CP_DEPEND="
	dev-java/commons-math:3
	dev-java/jopt-simple:0"

DEPEND=">=virtual/jdk-1.8:*
	${CP_DEPEND}"

RDEPEND=">=virtual/jre-1.8:*
	${CP_DEPEND}"

S="${WORKDIR}/jmh-${PV}"

JAVA_SRC_DIR="jmh-core/src/main/java"
JAVA_RESOURCE_DIRS="jmh-core/src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="jmh-core/src/test/java"
JAVA_TEST_RESOURCE_DIRS="jmh-core/src/test/resources"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
