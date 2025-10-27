# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

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
		https://issues.apache.org/jira/secure/attachment/13076859/Keyboard.ttf
		https://mirrors.ctan.org/fonts/opensans/type1/OpenSans-Regular.pfb
		https://moji.or.jp/wp-content/ipafont/IPAfont/ipag00303.zip
	)
	verify-sig? ( https://downloads.apache.org/pdfbox/${PV}/pdfbox-${PV}-src.zip.asc )"
S="${WORKDIR}/pdfbox-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

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

JAVADOC_CLASSPATH="commons-logging"
JAVADOC_SRC_DIRS=( {fontbox,io}/src/main/java )
JAVA_TEST_GENTOO_CLASSPATH="junit-5"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/pdfbox.apache.org.asc"

PATCHES=( "${FILESDIR}/fontbox-3.0.6-skipUnknownHostException.patch" )

src_unpack() {
	use verify-sig && verify-sig_verify_detached "${DISTDIR}"/pdfbox-${PV}-src.zip{,.asc}
	default
}

src_prepare() {
	default	# bug #780585
	java-pkg-2_src_prepare
}

src_compile() {
	JAVA_AUTOMATIC_MODULE_NAME="org.apache.pdfbox.io"
	JAVA_JAR_FILENAME="pdfbox-io.jar"
	JAVA_SRC_DIR="io/src/main/java"
	java-pkg-simple_src_compile
	rm -r target || die "rm target"
	JAVA_AUTOMATIC_MODULE_NAME="org.apache.fontbox"
	JAVA_GENTOO_CLASSPATH_EXTRA="pdfbox-io.jar"
	JAVA_JAR_FILENAME="fontbox.jar"
	JAVA_RESOURCE_DIRS="fontbox/src/main/resources"
	JAVA_SRC_DIR="fontbox/src/main/java"
	java-pkg-simple_src_compile
	use doc && ejavadoc
}

src_test() {
	JAVA_TEST_RESOURCE_DIRS="io/src/test/resources"
	JAVA_TEST_SRC_DIR="io/src/test/java"
	junit5_src_test

	mkdir -p src/test || die "mkdir"
	mv {fontbox/,}src/test/resources || die "move resources"
	mkdir --parents target/fonts || die
	cp \
		"${DISTDIR}"/DejaVuSansMono.ttf \
		"${DISTDIR}"/OpenSans-Regular.pfb \
		"${DISTDIR}"/NotoEmoji-Regular.ttf \
		"${DISTDIR}"/NotoMono-Regular.ttf \
		"${DISTDIR}"/Keyboard.ttf \
		"${DISTDIR}"/DejaVuSerifCondensed.pfb \
		"${DISTDIR}"/NotoSansSC-Regular.otf \
		"${DISTDIR}"/SourceSansProBold.otf \
		"target/fonts" || die
	unzip "${DISTDIR}"/ipag00303.zip -d "target/fonts" || die

	JAVA_TEST_RESOURCE_DIRS="src/test/resources"
	JAVA_TEST_SRC_DIR="fontbox/src/test/java"
	junit5_src_test
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar pdfbox-io.jar
}
