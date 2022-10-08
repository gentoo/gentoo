# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/pdfbox/2.0.27/pdfbox-2.0.27-src.zip --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild fontbox-2.0.27.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.pdfbox:fontbox:2.0.27"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An open source Java library for parsing font files"
HOMEPAGE="https://pdfbox.apache.org/"
SRC_URI="mirror://apache/pdfbox/${PV}/pdfbox-${PV}-src.zip
	test? (
		https://issues.apache.org/jira/secure/attachment/12684264/SourceSansProBold.otf
		https://issues.apache.org/jira/secure/attachment/12896461/NotoEmoji-Regular.ttf
		https://issues.apache.org/jira/secure/attachment/12809395/DejaVuSansMono.ttf
		https://issues.apache.org/jira/secure/attachment/13036376/NotoSansSC-Regular.otf
		https://mirrors.ctan.org/fonts/opensans/type1/OpenSans-Regular.pfb
	)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

# Common dependencies
# POM: pom.xml
# commons-logging:commons-logging:1.2 -> >=dev-java/commons-logging-1.2:0

CP_DEPEND="dev-java/commons-logging:0"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/pdfbox-${PV}/${PN}"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.fontbox"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	mkdir --parents target/{pdfs,fonts} || die
	cp \
		"${DISTDIR}"/SourceSansProBold.otf \
		"${DISTDIR}"/NotoEmoji-Regular.ttf \
		"${DISTDIR}"/DejaVuSansMono.ttf \
		"${DISTDIR}"/NotoSansSC-Regular.otf \
		"target/pdfs" || die
	cp "${DISTDIR}"/OpenSans-Regular.pfb \
		"target/fonts" || die

	java-pkg-simple_src_test
}
