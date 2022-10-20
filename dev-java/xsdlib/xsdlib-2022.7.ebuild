# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/xmlark/msv/archive/msv-2022.7.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild xsdlib-2022.7.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="net.java.dev.msv:xsdlib:2022.7"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XML Schema datatypes library"
HOMEPAGE="https://github.com/xmlark/msv/tree/main/xsdlib"
SRC_URI="https://github.com/xmlark/msv/archive/msv-${PV}.tar.gz"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

# Common dependencies
# POM: pom.xml
# relaxngDatatype:relaxngDatatype:20020414 -> >=dev-java/relaxng-datatype-20020414:0
# xerces:xercesImpl:2.12.2 -> >=dev-java/xerces-2.12.2:2

CP_DEPEND="
	dev-java/relaxng-datatype:0
	dev-java/xerces:2
"

# Compile dependencies
# POM: pom.xml
# test? junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4
# test? org.jdom:jdom2:2.0.6.1 -> >=dev-java/jdom-2.0.6.1:2

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		dev-java/jdom:2
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/msv-msv-${PV}/xsdlib"

JAVA_MAIN_CLASS="com.sun.msv.datatype.xsd.CommandLineTester"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,jdom-2"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	# Selection according to pom.xml#L156-L184
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
