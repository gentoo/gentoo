# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/FasterXML/jackson-dataformat-xml/archive/refs/tags/jackson-dataformat-xml-2.13.0.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jackson-dataformat-xml-2.13.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.fasterxml.jackson.dataformat:jackson-dataformat-xml:2.13.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Data format extension for Jackson"
HOMEPAGE="https://github.com/FasterXML/jackson-dataformat-xml"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# com.fasterxml.jackson.core:jackson-annotations:2.13.0 -> >=dev-java/jackson-annotations-2.13.0:2
# com.fasterxml.jackson.core:jackson-core:2.13.0 -> >=dev-java/jackson-core-2.13.0:0
# com.fasterxml.jackson.core:jackson-databind:2.13.0 -> >=dev-java/jackson-databind-2.13.0:0
# com.fasterxml.woodstox:woodstox-core:6.2.6 -> >=dev-java/woodstox-core-6.2.7:0
# org.codehaus.woodstox:stax2-api:4.2.1 -> >=dev-java/stax2-api-4.2.1:0

CP_DEPEND="
	>=dev-java/jackson-annotations-2.13.0:2
	>=dev-java/jackson-core-2.13.0:0
	>=dev-java/jackson-databind-2.13.0:0
	>=dev-java/stax2-api-4.2.1:0
	>=dev-java/woodstox-core-6.2.7:0
"

# Compile dependencies
# POM: pom.xml
# test? com.fasterxml.jackson.module:jackson-module-jakarta-xmlbind-annotations:2.13.0 -> >=dev-java/jackson-module-jakarta-xmlbind-2.13.0:0
# test? com.sun.xml.stream:sjsxp:1.0.2 -> >=dev-java/sjsxp-1.0.2:0
# test? jakarta.xml.bind:jakarta.xml.bind-api:3.0.1 -> >=dev-java/jaxb-api-3.0.1:3
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.2:4

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/jackson-module-jakarta-xmlbind:0
		dev-java/jaxb-api:3
		dev-java/sjsxp:0
	)
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( LICENSE README.md release-notes/{CREDITS,VERSION}-2.x )

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR=( "src/main/java" "src/moditect" )
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="jackson-module-jakarta-xmlbind,sjsxp,jaxb-api-3,junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_EXCLUDES=(
	# Upstream: Tests run: 316, Failures: 0, Errors: 0, Skipped: 0
	# All the following are not run by upstream (mvn test).
	com.fasterxml.jackson.dataformat.xml.failing.ConflictingGetters27Test
	com.fasterxml.jackson.dataformat.xml.failing.ElementWrapperViaCreator149Test
	com.fasterxml.jackson.dataformat.xml.failing.EnumIssue9Test
	com.fasterxml.jackson.dataformat.xml.failing.Issue37AdapterTest
	com.fasterxml.jackson.dataformat.xml.failing.Issue491NoArgCtorDeserRegressionTest
	com.fasterxml.jackson.dataformat.xml.failing.PojoAsAttributeSer128Test
	com.fasterxml.jackson.dataformat.xml.failing.PolymorphicIssue4Test
	com.fasterxml.jackson.dataformat.xml.failing.PolymorphicList426Test
	com.fasterxml.jackson.dataformat.xml.failing.UntypedListSerialization8Test
	com.fasterxml.jackson.dataformat.xml.failing.UnwrappedAndList299DeserTest
	com.fasterxml.jackson.dataformat.xml.failing.VerifyRootLocalName247Test
	com.fasterxml.jackson.dataformat.xml.failing.XmlTextViaCreator306Test
	com.fasterxml.jackson.dataformat.xml.failing.XmlTextWithEmpty449Test
)

src_prepare() {
	java-pkg-2_src_prepare

	sed -e 's:@package@:com.fasterxml.jackson.dataformat.xml:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.dataformat:g' \
		-e "s:@projectartifactid@:${PN}:g" \
		"${JAVA_SRC_DIR}/com/fasterxml/jackson/dataformat/xml/PackageVersion.java.in" \
		> "${JAVA_SRC_DIR}/com/fasterxml/jackson/dataformat/xml/PackageVersion.java" || die
}

src_test() {
	# The same failure occurs upstream (running 'mvn test')

	# 1) testCollection(com.fasterxml.jackson.dataformat.xml.lists.ListAsObjectTest)
	# com.fasterxml.jackson.databind.exc.InvalidDefinitionException: Failed to call `setAccess()` on Field 'first' due to
	# `java.lang.reflect.InaccessibleObjectException`, problem: Unable to make field transient java.util.LinkedList$Node
	# java.util.LinkedList.first accessible: module java.base does not "opens java.util" to unnamed module @42bb2aee

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge "17" ; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.util=ALL-UNNAMED )
	fi

	java-pkg-simple_src_test
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
