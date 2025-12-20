# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.javassist:javassist:3.30.2-GA"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A class library for editing bytecodes in Java."
HOMEPAGE="https://www.javassist.org"
SRC_URI="https://github.com/jboss-javassist/javassist/archive/rel_${PV//./_}_ga.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-rel_${PV//./_}_ga"

LICENSE="Apache-2.0 LGPL-2.1 MPL-1.1"
SLOT="3"
KEYWORDS="amd64 arm64 ppc64"

# src/main/javassist/tools/rmi/ObjectImporter.java:99: error: package java.applet does not exist
#     public ObjectImporter(@SuppressWarnings("deprecation") java.applet.Applet applet) {
#                                                                       ^
# See https://bugs.openjdk.org/browse/JDK-8359053 - so we exclude jdk:26
DEPEND="
	|| ( virtual/jdk:25 virtual/jdk:21 virtual/jdk:17 virtual/jdk:11 )
	test? ( dev-java/hamcrest-library:1.3 )
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( Changes.md README.md )
HTML_DOCS=( tutorial/{brown.css,tutorial.html,tutorial2.html,tutorial3.html} )

PATCHES=(
	"${FILESDIR}/javassist-3.29.2-gentoo.patch"
	"${FILESDIR}/javassist-3.30.2-skip_testDeprecatedAttribute.patch"
)

JAVA_AUTOMATIC_MODULE_NAME="org.javassist"
JAVA_MAIN_CLASS="javassist.CtClass"
JAVA_SRC_DIR="src/main"

JAVA_TEST_GENTOO_CLASSPATH="hamcrest-library-1.3,junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_RUN_ONLY="javassist.JvstTest" # pom.xml, line 167
JAVA_TEST_SRC_DIR="src/test"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	java-pkg_clean ! -path "./src/test*"
}

src_test() {
	einfo "Testing"
	JAVA_PKG_WANT_SOURCE=11
	JAVA_PKG_WANT_TARGET=11
	JAVAC_ARGS="-g -parameters"
	java-pkg-simple_src_test
}
