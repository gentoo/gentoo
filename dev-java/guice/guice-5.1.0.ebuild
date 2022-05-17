# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom core/pom.xml --download-uri https://github.com/google/guava/archive/v30.1.1.tar.gz --slot 5 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x866" --ebuild guice-5.1.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.inject:guice:5.1.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Guice is a lightweight dependency injection framework for Java 6 and above"
HOMEPAGE="https://github.com/google/guice"
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

# Most of the test dependencies are missing in Gentoo.
RESTRICT="test"

# Common dependencies
# POM: core/pom.xml
# aopalliance:aopalliance:1.0 -> >=dev-java/aopalliance-1.0:1
# com.google.guava:guava:30.1-jre -> >=dev-java/guava-30.1.1:0
# javax.inject:javax.inject:1 -> >=dev-java/javax-inject-1:0
# org.ow2.asm:asm:9.2 -> >=dev-java/asm-9.2:9

CP_DEPEND="
	dev-java/aopalliance:1
	dev-java/asm:9
	dev-java/guava:0
	dev-java/javax-inject:0
"

# Compile dependencies
# POM: core/pom.xml
# test? biz.aQute:bnd:0.0.384 -> !!!groupId-not-found!!!
# test? com.google.guava:guava-testlib:30.1-jre -> >=dev-java/guava-testlib-30.1.1:0
# test? com.google.truth:truth:0.45 -> !!!groupId-not-found!!!
# test? javax.inject:javax.inject-tck:1 -> !!!artifactId-not-found!!!
# test? junit:junit:4.13 -> >=dev-java/junit-4.13.2:4
# test? org.apache.felix:org.apache.felix.framework:3.0.5 -> !!!groupId-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	test? (
		dev-java/guava-testlib:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

DOCS=( {COPYING,{CONTRIBUTING,README}.md} )

S="${WORKDIR}/${P}"

JAVA_SRC_DIR=( "core/src" )
JAVA_RESOURCE_DIRS=( "core/res" )

JAVA_TEST_GENTOO_CLASSPATH="guava-testlib,junit-4"
JAVA_TEST_SRC_DIR=( "core/test" )
JAVA_TEST_RESOURCE_DIRS=( "core/test" )

src_prepare() {
	default
	mkdir -p "core/res/com/google/inject/" || die
	cp core/{src,res}/com/google/inject/BUILD || die
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
