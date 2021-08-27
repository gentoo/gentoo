# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom jbig2-imageio-3.0.3/pom.xml --download-uri https://downloads.apache.org/pdfbox/jbig2-imageio/3.0.3/jbig2-imageio-3.0.3-src.zip --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild jbig2-imageio-3.0.3.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.pdfbox:jbig2-imageio:3.0.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="PDFBox JBIG2 ImageIO plugin"
HOMEPAGE="https://pdfbox.apache.org"
SRC_URI="https://downloads.apache.org/pdfbox/${PN}/${PV}/${P}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

JAVA_SRC_DIR="${P}/src/main/java"
JAVA_RESOURCE_DIRS="${P}/src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="${P}/src/test/java"
JAVA_TEST_RESOURCE_DIRS="${P}/src/test/resources"

JAVA_TEST_EXCLUDES=(
	# org.junit.runners.model.InvalidTestClassError: Invalid test class
	#  1. Test class should have exactly one public constructor
	"org.apache.pdfbox.jbig2.util.TestServiceImpl"
	"org.apache.pdfbox.jbig2.util.TestService"
)
