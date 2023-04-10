# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jdom:jdom2:2.0.6.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java-based solution for accessing, manipulating, and outputting XML data"
HOMEPAGE="http://www.jdom.org"
SRC_URI="https://github.com/hunterhacker/jdom/archive/${PN^^}-${PV}.tar.gz"
S="${WORKDIR}/jdom-JDOM-${PV}"

LICENSE="Apache-1.1"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

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

PATCHES=( "${FILESDIR}/jdom-2.0.6.1-skip-failing-tests.patch" )

JAVA_TEST_GENTOO_CLASSPATH="junit-4,xerces-2"
JAVA_TEST_RESOURCE_DIRS="test/src/resources"
JAVA_TEST_SRC_DIR="test/src/java"

src_prepare() {
	java-pkg-2_src_prepare
	default # bug #780585
	java-pkg_clean

	mkdir core/resources || die
	cp -r core/{package,resources}/META-INF || die

	# Remove Android stuff to avoid junit RDEPEND.
	rm -vr contrib/src/java/org/jdom2/contrib/android || die

	cd test/src/java || die
	# java-pkg-simple.eclass expects test resources in JAVA_TEST_RESOURCE_DIRS
	find . -type f ! -name '*.java' \
		| xargs cp --parent -t ../resources || die

	# We skip testDocTypeDocument() from 3 test classes due to test failures,
	# see bug #901743. This requires changing also the line endings which would
	# lead to huge patches. Hence we do this with sed ( 's/\r$//g' ).
	sed \
		-e 's/\r$//g' \
		-e '/import org.junit.Test/a import org.junit.Ignore;' \
		-e '/testDocTypeDocument()/i @Ignore' \
		-i org/jdom2/test/cases/input/TestDOMBuilder.java \
		-i org/jdom2/test/cases/input/TestStAXEventBuilder.java \
		-i org/jdom2/test/cases/input/TestStAXStreamBuilder.java || die
}

src_compile() {
	JAVA_JAR_FILENAME="jdom.jar"
	JAVA_RESOURCE_DIRS="core/resources"
	JAVA_SRC_DIR="core/src/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":jdom.jar"
	rm -rf target || die

	JAVA_JAR_FILENAME="jdom-contrib.jar"
	JAVA_RESOURCE_DIRS="contrib/src/resources"
	JAVA_SRC_DIR="contrib/src/java"
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
	default # install README
	java-pkg_dojar "jdom.jar"
	java-pkg_dojar "jdom-contrib.jar"
	if use doc; then
		java-pkg_dojavadoc target/api
	fi
	if use source; then
		java-pkg_dosrc "core/src/java/*" "contrib/src/java/*"
	fi
}
