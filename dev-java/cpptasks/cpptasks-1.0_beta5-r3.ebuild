# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source test"
JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Ant-tasks to compile various source languages and produce executables"
HOMEPAGE="https://ant-contrib.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/ant-contrib/ant-contrib/${P/_/-}/${P/_beta/b}.tar.gz"
S="${WORKDIR}/${P/_beta/b}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="
	>=dev-java/ant-1.10.14:0
	dev-java/xerces:2
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/ant-1.10.14:0[junit]
		dev-java/junit:0
	)
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( NOTICE )

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_RUN_ONLY=( net.sf.antcontrib.cpptasks.TestAllClasses )
JAVA_TEST_SRC_DIR="src/test/java"

src_install() {
	java-pkg-simple_src_install
	java-pkg_register-ant-task
	use examples && java-pkg_doexamples src/samples/*
}
