# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/xmlark/msv/archive/msv-2022.7.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild msv-2022.7.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="net.java.dev.msv:msv-core:2022.7"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Multi-Schema Validator Core package"
HOMEPAGE="https://github.com/xmlark/msv/msv-core"
SRC_URI="https://github.com/xmlark/msv/archive/msv-${PV}.tar.gz"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# isorelax:isorelax:20030108 -> !!!groupId-not-found!!!
# net.java.dev.msv:xsdlib:2022.7 -> !!!suitable-mavenVersion-not-found!!!
# relaxngDatatype:relaxngDatatype:20020414 -> >=dev-java/relaxng-datatype-20020414:0
# xerces:xercesImpl:2.12.2 -> >=dev-java/xerces-2.12.2:2
# xml-apis:xml-apis:1.4.01 -> >=dev-java/xml-commons-external-1.4.01:1.4
# xml-resolver:xml-resolver:1.2 -> >=dev-java/xml-commons-resolver-1.2:0

CP_DEPEND="
	dev-java/iso-relax:0
	dev-java/relaxng-datatype:0
	dev-java/xerces:2
	dev-java/xml-commons-external:1.4
	dev-java/xml-commons-resolver:0
	dev-java/xsdlib:0
"

DEPEND=">=virtual/jdk-1.8:*
	${CP_DEPEND}"

RDEPEND=">=virtual/jre-1.8:*
	${CP_DEPEND}"

S="${WORKDIR}/msv-${P}/msv"

JAVA_MAIN_CLASS="com.sun.msv.driver.textui.Driver"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_test() {
	# Selection according to pom.xml#L182-L210
	pushd src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			\( -wholename "**/*Test.java" \
			-o -wholename "**/*TestCase.java" \
			-o -wholename "**/*TestCases.java" \) \
			! -wholename "**/*\$*" \
			)
	popd
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}
