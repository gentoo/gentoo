# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jdom:jdom2:2.0.6.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java-based solution for accessing, manipulating, and outputting XML data"
HOMEPAGE="http://www.jdom.org"
SRC_URI="https://github.com/hunterhacker/jdom/archive/${PN^^}-${PV}.tar.gz"

LICENSE="Apache-1.1"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# FAILURES!!!
# Tests run: 1887,  Failures: 23
RESTRICT="test"

CP_DEPEND="
	dev-java/iso-relax:0
	dev-java/jaxen:1.2
	dev-java/xalan:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		dev-java/xerces:2
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/jdom-JDOM-${PV}"

JAVA_TEST_SRC_DIR="test/src/java"
JAVA_TEST_RESOURCE_DIRS="test/src/resources"
JAVA_TEST_GENTOO_CLASSPATH="junit-4,xerces-2"

src_prepare() {
	default
	java-pkg_clean

	# Remove Android stuff to avoid junit RDEPEND.
	rm -vr contrib/src/java/org/jdom2/contrib/android || die

	# There are resources in JAVA_TEST_SRC_DIR
	cp -r test/src/{java,resources}/org || die
	# Remove .java files from JAVA_TEST_RESOURCE_DIRS
	find test/src/resources -type f -name '*.java' -exec rm -rf {} + || die "deleting classes failed"
}

src_compile() {
	JAVA_SRC_DIR="core/src/java"
	JAVA_JAR_FILENAME="jdom.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":jdom.jar"
	rm -rf target || die

	JAVA_SRC_DIR="contrib/src/java"
	JAVA_RESOURCE_DIRS="contrib/src/resources"
	JAVA_JAR_FILENAME="jdom-contrib.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":jdom-contrib.jar"
	rm -rf target || die

	if use doc; then
		JAVA_SRC_DIR=()
		JAVA_SRC_DIR=(
			"core/src/java"
			"contrib/src/java"
		)
		JAVA_JAR_FILENAME="ignoreme.jar"
		java-pkg-simple_src_compile
	fi
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg_dojar "jdom.jar"
	java-pkg_dojar "jdom-contrib.jar"
	if use doc; then
		java-pkg_dojavadoc target/api
	fi
	if use source; then
		java-pkg_dosrc "core/src/java/*" "contrib/src/java/*"
	fi
}
