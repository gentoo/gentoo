# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.glassfish.jaxb:jaxb-runtime:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JAXB (JSR 222) Reference Implementation"
HOMEPAGE="https://eclipse-ee4j.github.io/jaxb-ri/"
SRC_URI="https://github.com/eclipse-ee4j/jaxb-ri/archive/${PV}-RI.tar.gz -> jaxb-ri-${PV}.tar.gz"
S="${WORKDIR}/jaxb-ri-${PV}-RI/jaxb-ri/runtime/impl"

LICENSE="EPL-1.0"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CP_DEPEND="
	dev-java/fastinfoset:0
	dev-java/istack-commons-runtime:3
	dev-java/jaxb-api:2
	dev-java/jaxb-stax-ex:1
	~dev-java/txw2-${PV}:2
"

DEPEND="
	>=virtual/jdk-11:*
	${CP_DEPEND}
	>=dev-java/jakarta-activation-api-1.2.2:1
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
	>=dev-java/jakarta-activation-1.2.2:1
"

JAVA_CLASSPATH_EXTRA="jakarta-activation-api-1"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	# Run this test separately as it prevents a reasonable test summary
	JAVA_TEST_RUN_ONLY="com.sun.xml.bind.v2.schemagen.XmlSchemaGeneratorTest"
	java-pkg-simple_src_test

	# The default test selection of java-pkg-simple would omit
	# "com.sun.xml.bind.v2.schemagen.MarshallingAbstractTest"
	pushd src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			-type f \
			-name "*Test.java" \
			! -name "XmlSchemaGeneratorTest.java" \
			)
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd
	java-pkg-simple_src_test
}
