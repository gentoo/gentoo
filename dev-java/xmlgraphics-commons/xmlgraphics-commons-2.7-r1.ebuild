# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/xmlgraphics/commons/source/2.7-src.tar.gz --slot 2 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild xmlgraphics-commons-2.7.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.xmlgraphics:xmlgraphics-commons:2.7"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XML Graphics Commons"
HOMEPAGE="https://xmlgraphics.apache.org/commons/"
SRC_URI="mirror://apache/xmlgraphics/commons/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 arm64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# commons-io:commons-io:1.3.2 -> >=dev-java/commons-io-2.11.0:1
# commons-logging:commons-logging:1.2 -> >=dev-java/commons-logging-1.2:0

CP_DEPEND="
	dev-java/commons-io:1
	dev-java/commons-logging:0
"

# Compile dependencies
# POM: pom.xml
# test? junit:junit:4.11 -> >=dev-java/junit-4.13.2:4
# test? org.mockito:mockito-core:2.28.2 -> !!!suitable-mavenVersion-not-found!!!
# test? xml-resolver:xml-resolver:1.2 -> >=dev-java/xml-commons-resolver-1.2:0

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/mockito:4
		dev-java/xml-commons-resolver:0
	)"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( NOTICE README )

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,mockito-4,xml-commons-resolver"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

# There are test failures, bug #832058
JAVA_TEST_EXCLUDES=(
	"org.apache.xmlgraphics.image.codec.tiff.TIFFImageEncoderTestCase"
	"org.apache.xmlgraphics.image.loader.impl.ImageLoaderImageIOTestCase"
	"org.apache.xmlgraphics.io.XmlSourceUtilTestCase"
	"org.apache.xmlgraphics.ps.dsc.ListenerTestCase"
	"org.apache.xmlgraphics.xmp.XMPParserTestCase"
)

src_install() {
	java-pkg-simple_src_install
	einstalldocs # https://bugs.gentoo.org/789582
}
