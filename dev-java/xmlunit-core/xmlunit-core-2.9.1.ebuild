# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.xmlunit:xmlunit-core:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XMLUnit for Java"
HOMEPAGE="https://www.xmlunit.org/"
SRC_URI="https://github.com/xmlunit/xmlunit/releases/download/v${PV}/xmlunit-${PV}-src.tar.gz"
S="${WORKDIR}/xmlunit-${PV}-src/xmlunit-core"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CP_DEPEND="
	dev-java/jaxb-api:2
"

DEPEND="
	>=virtual/jdk-1.8:*
	dev-java/jaxb-runtime:2
	${CP_DEPEND}
	test? (
		dev-java/hamcrest:0
		dev-java/istack-commons-runtime:3
		dev-java/mockito:4
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

DOCS=( ../{CONTRIBUTING,HELP_WANTED,README,RELEASE_NOTES}.md )

JAVA_AUTOMATIC_MODULE_NAME="org.xmlunit"
JAVA_CLASSPATH_EXTRA="jaxb-runtime-2"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_EXCLUDES=(
	# org.junit.runners.model.InvalidTestClassError: Invalid test class
	org.xmlunit.TestResources
)
JAVA_TEST_GENTOO_CLASSPATH="
	hamcrest
	istack-commons-runtime-3
	junit-4
	mockito-4
"
JAVA_TEST_SRC_DIR="src/test/java"
