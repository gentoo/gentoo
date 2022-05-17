# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/pdfbox/2.0.26/pdfbox-2.0.26-src.zip --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild xmpbox-2.0.26.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.pdfbox:xmpbox:2.0.26"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An open source Java tool that implements Adobe's XMP(TM) specification"
HOMEPAGE="https://pdfbox.apache.org"
SRC_URI="mirror://apache/pdfbox/${PV}/pdfbox-${PV}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

# Common dependencies
# POM: pom.xml
# commons-logging:commons-logging:1.2 -> >=dev-java/commons-logging-1.2:0

CP_DEPEND="dev-java/jaxb-api:2"

# Compile dependencies
# POM: pom.xml
# javax.xml.bind:jaxb-api:2.3.1 -> !!!groupId-not-found!!!
# POM: pom.xml
# test? junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/pdfbox-${PV}/${PN}"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

JAVA_TEST_EXCLUDES=(
	# 1) initializationError(org.apache.xmpbox.parser.PropMappingTest)
	# org.junit.runners.model.InvalidTestClassError: Invalid test class 'org.apache.xmpbox.parser.PropMappingTest':
	#   1. No runnable methods
	org.apache.xmpbox.parser.PropMappingTest
)

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
