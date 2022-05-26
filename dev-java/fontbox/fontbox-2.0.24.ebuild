# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pdfbox-2.0.24/fontbox/pom.xml --download-uri https://downloads.apache.org/pdfbox/2.0.24/pdfbox-2.0.24-src.zip --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild fontbox-2.0.24.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.pdfbox:fontbox:2.0.24"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An open source Java library for parsing font files"
HOMEPAGE="https://pdfbox.apache.org/"
SRC_URI="mirror://apache/pdfbox/${PV}/pdfbox-${PV}-src.zip
	test? (
		https://issues.apache.org/jira/secure/attachment/12684264/SourceSansProBold.otf
		https://issues.apache.org/jira/secure/attachment/12896461/NotoEmoji-Regular.ttf
		https://issues.apache.org/jira/secure/attachment/12809395/DejaVuSansMono.ttf
	)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 x86"

# Common dependencies
# POM: pdfbox-${PV}/${PN}/pom.xml
# commons-logging:commons-logging:1.2 -> >=dev-java/commons-logging-1.2:0

CDEPEND="dev-java/commons-logging:0"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/pdfbox-${PV}/${PN}"

JAVA_GENTOO_CLASSPATH="commons-logging"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_test() {
	mkdir --parents target/pdfs || die
	cp "${DISTDIR}"/DejaVuSansMono.ttf \
		"${DISTDIR}"/NotoEmoji-Regular.ttf \
		"${DISTDIR}"/SourceSansProBold.otf \
		"target/pdfs" || die

	java-pkg-simple_src_test
}
