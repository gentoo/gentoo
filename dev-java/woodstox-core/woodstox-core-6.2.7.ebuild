# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/FasterXML/woodstox/archive/refs/tags/woodstox-core-6.2.7.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild woodstox-core-6.2.7.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.fasterxml.woodstox:woodstox-core:6.2.7"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An XML processor that implements Stax (JSR-173), SAX2 and Stax2 APIs"
HOMEPAGE="https://github.com/FasterXML/woodstox"
SRC_URI="https://github.com/FasterXML/woodstox/archive/refs/tags/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# net.java.dev.msv:msv-core:2013.6.1 -> !!!artifactId-not-found!!!
# net.java.dev.msv:xsdlib:2013.6.1 -> >=dev-java/xsdlib-20090415:0
# org.codehaus.woodstox:stax2-api:4.2.1 -> >=dev-java/stax2-api-4.2.1:0
# relaxngDatatype:relaxngDatatype:20020414 -> !!!groupId-not-found!!!

CP_DEPEND="
	dev-java/msv:0
	dev-java/relaxng-datatype:0
	dev-java/stax2-api:0
	dev-java/xsdlib:0
"

# Compile dependencies
# POM: pom.xml
# org.apache.felix:org.osgi.core:1.4.0 -> !!!groupId-not-found!!!
# POM: pom.xml
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.2:4

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	dev-java/osgi-core-api:0"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( LICENSE {README,SECURITY}.md release-notes/{CREDITS,VERSION} )

S="${WORKDIR}/woodstox-${P}"

JAVA_CLASSPATH_EXTRA="osgi-core-api"
JAVA_SRC_DIR=( "src/main/java" "src/moditect" )
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

JAVA_TEST_EXCLUDES=(
	# Upstream: Tests run: 864, Failures: 0, Errors: 0, Skipped: 0
	# "No tests found in ..."
	wstxtest.vstream.BaseValidationTest
	wstxtest.BaseWstxTest
	stax2.vstream.BaseStax2ValidationTest
	stax2.BaseStax2Test
	stax2.wstream.BaseWriterTest
	org.codehaus.stax.test.BaseStaxTest
	org.codehaus.stax.test.wstream.BaseWriterTest
	org.codehaus.stax.test.stream.BaseStreamTest
	# "... has no public constructor"
	wstxtest.stream.BaseStreamTest
	wstxtest.wstream.BaseWriterTest
	stax2.vwstream.BaseOutputTest
	org.codehaus.stax.test.vstream.BaseVStreamTest
	org.codehaus.stax.test.evt.BaseEventTest
	# Upstream does not run these:
	failing.TestBasicSax
	failing.TestExtLocationInfo91
	failing.TestRelaxNG
	failing.TestW3CDefaultValues
	failing.TestW3CDefaultValues
	failing.TestW3CSchemaComplexTypes
	failing.TestW3CSchemaTypes
	failing.TestW3CSchemaTypes
)

src_prepare() {
	default

	#rc/moditect/module-info.java:32: error: package com.ctc.wstx.shaded.msv.relaxng_datatype does not exist
	#    provides com.ctc.wstx.shaded.msv.relaxng_datatype.DatatypeLibraryFactory with com.ctc.wstx.shaded.msv_core.datatype.xsd.ngimpl.DataTypeLibraryImpl;
	#                                                     ^
	#src/moditect/module-info.java:32: error: package com.ctc.wstx.shaded.msv_core.datatype.xsd.ngimpl does not exist
	#    provides com.ctc.wstx.shaded.msv.relaxng_datatype.DatatypeLibraryFactory with com.ctc.wstx.shaded.msv_core.datatype.xsd.ngimpl.DataTypeLibraryImpl
	sed -e '/com.ctc.wstx.shaded.msv/d' \
		-e '/org.codehaus.stax2.validation/d' \
		-i "src/moditect/module-info.java" || die
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
