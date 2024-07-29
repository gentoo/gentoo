# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.lmax:disruptor:3.4.4"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A High Performance Inter-Thread Messaging Library"
HOMEPAGE="https://lmax-exchange.github.io/disruptor/"
SRC_URI="https://github.com/LMAX-Exchange/disruptor/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( LICENCE.txt README.md )

S="${WORKDIR}/disruptor-${PV}"

JAVA_SRC_DIR="src/main"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_EXCLUDES=(
	# valid test classes have pattern *Test with nothing behind
	com.lmax.disruptor.dsl.stubs.TestWorkHandler # No runnable methods
	com.lmax.disruptor.support.TestEvent # No runnable methods
	com.lmax.disruptor.support.TestWaiter # No runnable methods
)

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
