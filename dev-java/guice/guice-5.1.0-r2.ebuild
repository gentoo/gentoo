# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.inject:guice:5.1.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Guice is a lightweight dependency injection framework for Java 6 and above"
HOMEPAGE="https://github.com/google/guice"
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="~amd64 ~arm64 ~ppc64"

# Most of the test dependencies are missing in Gentoo.
RESTRICT="test"

CP_DEPEND="
	dev-java/aopalliance:1
	dev-java/asm:0
	>=dev-java/error-prone-annotations-2.41.0:0
	dev-java/guava:0
	dev-java/javax-inject:0
	dev-java/jsr305:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		dev-java/guava-testlib:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

DOCS=( {COPYING,{CONTRIBUTING,README}.md} )

JAVA_SRC_DIR=( "core/src" )
JAVA_RESOURCE_DIRS=( "core/res" )

JAVA_TEST_GENTOO_CLASSPATH="guava-testlib,junit-4"
JAVA_TEST_SRC_DIR=( "core/test" )
JAVA_TEST_RESOURCE_DIRS=( "core/test" )

src_prepare() {
	java-pkg-2_src_prepare
	mkdir -p "core/res/com/google/inject/" || die
	cp core/{src,res}/com/google/inject/BUILD || die
}
