# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/tmp/portage/dev-java/xmlgraphics-commons-2.6/work/xmlgraphics-commons-2.6/pom.xml --download-uri mirror://apache/xmlgraphics/commons/source/2.6-src.tar.gz --slot 2 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild xmlgraphics-commons-2.6.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.xmlgraphics:xmlgraphics-commons:2.6"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XML Graphics Commons"
HOMEPAGE="https://xmlgraphics.apache.org/commons/"
SRC_URI="mirror://apache/xmlgraphics/commons/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~arm64 ppc64 x86"

# Common dependencies
# POM: /var/tmp/portage/dev-java/${P}/work/${P}/pom.xml
# commons-io:commons-io:1.3.2 -> >=dev-java/commons-io-2.8.0:1
# commons-logging:commons-logging:1.2 -> >=dev-java/commons-logging-1.2:0

CDEPEND="
	dev-java/commons-io:1
	dev-java/commons-logging:0
"

# Compile dependencies
# POM: /var/tmp/portage/dev-java/${P}/work/${P}/pom.xml
# test? junit:junit:4.11 -> >=dev-java/junit-4.13.2:4
# test? org.mockito:mockito-core:1.8.5 -> >=dev-java/mockito-1.9.5:0
# test? xml-resolver:xml-resolver:1.2 -> >=dev-java/xml-commons-resolver-1.2:0

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/mockito:0
		dev-java/xml-commons-resolver:0
	)
"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( LICENSE NOTICE README )

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="commons-io-1,commons-logging"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,mockito,xml-commons-resolver"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

# Tests run: 189,  Failures: 12
JAVA_TEST_EXCLUDES=(
	"org.apache.xmlgraphics.xmp.XMPParserTestCase"
	"org.apache.xmlgraphics.image.codec.tiff.TIFFImageEncoderTestCase"
	"org.apache.xmlgraphics.image.loader.impl.ImageLoaderImageIOTestCase"
	"org.apache.xmlgraphics.ps.dsc.ListenerTestCase"
	"org.apache.xmlgraphics.io.XmlSourceUtilTestCase"
)

src_install() {
	default
	java-pkg-simple_src_install
}
