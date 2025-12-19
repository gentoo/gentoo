# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.pdfbox:fontbox:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="An open source Java library for parsing font files"
HOMEPAGE="https://pdfbox.apache.org/"
SRC_URI="mirror://apache/pdfbox/${PV}/pdfbox-${PV}-src.zip
	test? (
		https://issues.apache.org/jira/secure/attachment/12684264/SourceSansProBold.otf
		https://issues.apache.org/jira/secure/attachment/12809395/DejaVuSansMono.ttf
		https://issues.apache.org/jira/secure/attachment/12896461/NotoEmoji-Regular.ttf
		https://issues.apache.org/jira/secure/attachment/13036376/NotoSansSC-Regular.otf
		https://issues.apache.org/jira/secure/attachment/13064282/DejaVuSerifCondensed.pfb
		https://issues.apache.org/jira/secure/attachment/13065025/NotoMono-Regular.ttf
		https://mirrors.ctan.org/fonts/opensans/type1/OpenSans-Regular.pfb
		https://moji.or.jp/wp-content/ipafont/IPAfont/ipag00303.zip
	)
	verify-sig? ( https://downloads.apache.org/pdfbox/${PV}/pdfbox-${PV}-src.zip.asc )"
S="${WORKDIR}/pdfbox-${PV}/${PN}"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 arm64 ppc64"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/pdfbox.apache.org.asc"
BDEPEND="
	app-arch/unzip
	verify-sig? ( sec-keys/openpgp-keys-apache-pdfbox )
"
CP_DEPEND="dev-java/commons-logging:0"
DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"
RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.fontbox"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached \
			"${DISTDIR}/pdfbox-${PV}-src.zip" \
			"${DISTDIR}/pdfbox-${PV}-src.zip.asc"
	fi
	default
}

src_test() {
	mkdir --parents target/{pdfs,fonts} || die
	cp \
		"${DISTDIR}"/SourceSansProBold.otf \
		"${DISTDIR}"/NotoEmoji-Regular.ttf \
		"${DISTDIR}"/NotoSansSC-Regular.otf \
		"target/pdfs" || die
	cp \
		"${DISTDIR}"/DejaVuSansMono.ttf \
		"${DISTDIR}"/OpenSans-Regular.pfb \
		"${DISTDIR}"/NotoEmoji-Regular.ttf \
		"${DISTDIR}"/NotoMono-Regular.ttf \
		"${DISTDIR}"/DejaVuSerifCondensed.pfb \
		"${DISTDIR}"/NotoSansSC-Regular.otf \
		"${DISTDIR}"/SourceSansProBold.otf \
		"target/fonts" || die
	unzip "${DISTDIR}"/ipag00303.zip -d "target/fonts" || die

	java-pkg-simple_src_test
}
