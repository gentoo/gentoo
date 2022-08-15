# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/jboss-javassist/javassist/archive/rel_3_29_1_ga.tar.gz --slot 3 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild javassist-3.29.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.javassist:javassist:3.29.1-GA"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A class library for editing bytecodes in Java."
HOMEPAGE="https://www.javassist.org"
SRC_URI="https://github.com/jboss-javassist/javassist/archive/rel_${PV//./_}_ga.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 LGPL-2.1 MPL-1.1"
SLOT="3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"

# Tests run: 431,  Failures: 6
# Cannot solve those test failures. Using "mvn test" they all pass.
# https://bugs.gentoo.org/856364
RESTRICT="test"

# Compile dependencies
# POM: pom.xml
# test? junit:junit:[4.13.1,) -> >=dev-java/junit-4.13.2:4
# test? org.hamcrest:hamcrest-all:1.3 -> !!!artifactId-not-found!!!

DEPEND=">=virtual/jdk-11:*
	test? ( dev-java/hamcrest-library:1.3 )"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( Changes.md README.md )
HTML_DOCS=( tutorial/{brown.css,tutorial.html,tutorial2.html,tutorial3.html} )

S="${WORKDIR}/${PN}-rel_${PV//./_}_ga"

JAVA_AUTOMATIC_MODULE_NAME="org.javassist"
JAVA_MAIN_CLASS="javassist.CtClass"
JAVA_NEEDS_TOOLS=1
JAVA_SRC_DIR="src/main"

JAVA_TEST_GENTOO_CLASSPATH="hamcrest-library-1.3,junit-4"
JAVA_TEST_SRC_DIR="src/test"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

# https://github.com/jboss-javassist/javassist/blob/rel_3_29_0_ga/pom.xml#L166-L168
# <include>javassist/JvstTest.java</include>
JAVA_TEST_RUN_ONLY="javassist.JvstTest"

src_prepare() {
	default
	java-pkg_clean javassist.jar
	sed -e 's:\.\./\.\./::' -i src/test/javassist/JvstTest{4,Root}.java || die
}

src_test() {
	default
	einfo "Testing"
	JAVA_PKG_WANT_SOURCE=11
	JAVA_PKG_WANT_TARGET=11
	java-pkg-simple_src_test
}
