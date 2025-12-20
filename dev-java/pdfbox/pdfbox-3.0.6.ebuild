# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

ISSUES="https://issues.apache.org/jira/secure/attachment/"
L4J="2.25.2" # log4j-jcl is not packaged.

DESCRIPTION="Java library and utilities for working with PDF documents"
HOMEPAGE="https://pdfbox.apache.org/"
SRC_URI="mirror://apache/${PN}/${PV}/${P}-src.zip
	test? (
		https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-jcl/${L4J}/log4j-jcl-${L4J}.jar
		${ISSUES}/12421531/pdfboxpdfs.zip -> PDFBOX-515.zip
		${ISSUES}/12481683/1.pdf -> PDFBOX-1031-1.pdf
		${ISSUES}/12481684/2.pdf -> PDFBOX-1031-2.pdf
		${ISSUES}/12486525/1_testfile1.pdf -> PDFBOX-1065-1.pdf
		${ISSUES}/12486526/2_testfile1.pdf -> PDFBOX-1065-2.pdf
		${ISSUES}/12490774/a.pdf -> PDFBOX-1100-1.pdf
		${ISSUES}/12490775/b.pdf -> PDFBOX-1100-2.pdf
		${ISSUES}/12848122/SF1199AEG%20%28Complete%29.pdf -> PDFBOX-3656.pdf
		${ISSUES}/12852207/test.pdf -> PDFBOX-3682.pdf
		${ISSUES}/12888957/079977.pdf -> PDFBOX-3940-079977.pdf
		${ISSUES}/12867113/202097.pdf -> PDFBOX-3785-202097.pdf
		${ISSUES}/12890031/670064.pdf -> PDFBOX-3947-670064.pdf
		${ISSUES}/12890034/EUWO6SQS5TM4VGOMRD3FLXZHU35V2CP2.pdf -> PDFBOX-3948-EUWO6SQS5TM4VGOMRD3FLXZHU35V2CP2.pdf
		${ISSUES}/12890037/MKFYUGZWS3OPXLLVU2Z4LWCTVA5WNOGF.pdf -> PDFBOX-3949-MKFYUGZWS3OPXLLVU2Z4LWCTVA5WNOGF.pdf
		${ISSUES}/12890042/23EGDHXSBBYQLKYOKGZUOVYVNE675PRD.pdf -> PDFBOX-3950-23EGDHXSBBYQLKYOKGZUOVYVNE675PRD.pdf
		${ISSUES}/12890047/FIHUZWDDL2VGPOE34N6YHWSIGSH5LVGZ.pdf -> PDFBOX-3951-FIHUZWDDL2VGPOE34N6YHWSIGSH5LVGZ.pdf
		${ISSUES}/12892097/c687766d68ac766be3f02aaec5e0d713_2.pdf -> PDFBOX-3964-c687766d68ac766be3f02aaec5e0d713_2.pdf
		${ISSUES}/12893582/63NGFQRI44HQNPIPEJH5W2TBM6DJZWMI.pdf -> PDFBOX-3977-63NGFQRI44HQNPIPEJH5W2TBM6DJZWMI.pdf
		${ISSUES}/12896905/GeneralForbearance.pdf -> PDFBOX-3999-GeneralForbearance.pdf
		${ISSUES}/12919726/sample.pdf -> PDFBOX-4197.pdf
		${ISSUES}/12938094/Quelldatei.pdf -> PDFBOX-4308.pdf
		${ISSUES}/12952086/form.pdf -> PDFBOX-4408.pdf
		${ISSUES}/12953423/000314.pdf -> PDFBOX-4418-000314.pdf
		${ISSUES}/12953421/000671.pdf -> PDFBOX-4418-000671.pdf
		${ISSUES}/12953866/000746.pdf -> PDFBOX-4423-000746.pdf
		${ISSUES}/12966453/cryptfilter.pdf -> PDFBOX-4517-cryptfilter.pdf
		${ISSUES}/12991833/PDFBOX-4750-test.pdf -> PDFBOX-4750.pdf
		${ISSUES}/12914331/WXMDXCYRWFDCMOSFQJ5OAJIAFXYRZ5OA.pdf -> PDFBOX-4153-WXMDXCYRWFDCMOSFQJ5OAJIAFXYRZ5OA.pdf
		${ISSUES}/12962991/NeS1078.pdf -> PDFBOX-4490.pdf
		${ISSUES}/12784025/PDFBOX-3208-L33MUTT2SVCWGCS6UIYL5TH3PNPXHIS6.pdf
		${ISSUES}/12867102/PDFBOX-3783-72GLBIGUC6LB46ELZFBARRJTLN4RBSQM.pdf
		${ISSUES}/12929821/16bit.png -> PDFBOX-4184-16bit.png
		${ISSUES}/12943502/ArrayIndexOutOfBoundsException%20COSParser -> PDFBOX-4338.pdf
		${ISSUES}/12943503/NullPointerException%20COSParser -> PDFBOX-4339.pdf
		${ISSUES}/12867433/genko_oc_shiryo1.pdf
		https://moji.or.jp/wp-content/ipafont/IPAfont/ipag00303.zip
		https://moji.or.jp/wp-content/ipafont/IPAfont/ipagp00303.zip
		${ISSUES}/12911053/n019003l.pfb
		${ISSUES}/12949710/032163.jpg -> PDFBOX-4184-032163.jpg
		${ISSUES}/13025718/lotus.jpg -> PDFBOX-5196-lotus.jpg
		${ISSUES}/13002695/13._Korona_szallo_vegzes_13.09.26.eredeti.pdf -> PDFBOX-4831.pdf
		${ISSUES}/13015946/issue3323.pdf -> PDFBOX-5025.pdf
		${ISSUES}/13047577/PDFBOX-5484.ttf
		${ISSUES}/13061409/incorrect_password.pdf -> PDFBOX-5639.pdf
		${ISSUES}/13072508/sticky-notes.fdf -> PDFBOX-5894.fdf
		${ISSUES}/13074727/R%3D4%2C%20V%3D4%2C%2040-bit%20RC4.pdf -> PDFBOX-5955-40bit.pdf
		${ISSUES}/13074728/R%3D4%2C%20V%3D4%2C%2048-bit%20RC4.pdf -> PDFBOX-5955-48bit.pdf
		${ISSUES}/13074264/google-docs-1.pdf -> PDFBOX-5939-google-docs-1.pdf
		${ISSUES}/13076529/pdfbox-split-missing-tags_mail%2015.5.2025.pdf -> PDFBOX-6009.pdf
		${ISSUES}/13065529/source.pdf -> PDFBOX-5742.pdf
		${ISSUES}/13073586/SO79293670.pdf -> PDFBOX-5927.pdf
	)
	verify-sig? ( https://downloads.apache.org/pdfbox/${PV}/${P}-src.zip.asc )"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+tools"

BDEPEND="
	app-arch/unzip
	verify-sig? ( sec-keys/openpgp-keys-apache-pdfbox )
"
COMMON_DEPEND="
	tools? (
		>=dev-java/commons-io-2.20.0:0
		>=dev-java/picocli-4.6.3-r1:0
	)
"
CP_DEPEND="
	>=dev-java/bcpkix-1.82:0
	>=dev-java/bcprov-1.82:0
	>=dev-java/commons-logging-1.3.5:0
	~dev-java/fontbox-${PV}:0
"
DEPEND="
	${COMMON_DEPEND}
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/asm-9.9:0
		>=dev-java/byte-buddy-1.17.8:0
		~dev-java/diffutils-1.3.0:0
		dev-java/jai-imageio-core:0
		dev-java/jai-imageio-jpeg2000:0
		dev-java/jbig2-imageio:0
		>=dev-java/log4j-api-2.25.2:0
		>=dev-java/log4j-core-2.25.2:0
		>=dev-java/mockito-5.20.0-r1:0
	)
"
RDEPEND="
	${COMMON_DEPEND}
	${CP_DEPEND}
	>=dev-java/bcutil-1.82:0
	>=virtual/jre-1.8:*
"

DOCS=( README.md {NOTICE,RELEASE-NOTES}.txt )
PATCHES=(
	"${FILESDIR}/pdfbox-3.0.6-skipPDFontTest.patch"
	"${FILESDIR}/pdfbox-3.0.6-skipTestCOSIncrement.patch"
	"${FILESDIR}/pdfbox-3.0.6-skipPDAcroFormTest.patch"
)

JAVADOC_SRC_DIRS=( pdfbox/src/main/java )
JAVA_GENTOO_CLASSPATH_EXTRA="pdfbox.jar:pdfbox-debugger.jar"
JAVA_TEST_EXCLUDES=(
	# some test-classes want network: java.net.UnknownHostException: issues.apache.org
	org.apache.pdfbox.pdmodel.interactive.form.PDAcroFormFlattenTest	# 12 of 13 tests fail
	org.apache.pdfbox.pdmodel.interactive.form.TestRadioButtons	# 9 of 10 tests fail
	org.apache.pdfbox.pdmodel.interactive.form.PDAcroFormFromAnnotsTest	# 7 of 7 tests fail
	org.apache.pdfbox.pdmodel.interactive.form.PDAcroFormGenerateAppearancesTest	# 3 of 3 tests fail
	org.apache.pdfbox.pdmodel.interactive.form.PDFieldTreeTest	# 1 of 1 tests fail
)
JAVA_TEST_GENTOO_CLASSPATH="asm byte-buddy diffutils jai-imageio-core jai-imageio-jpeg2000 jbig2-imageio junit-5 log4j-api log4j-core mockito"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/pdfbox.apache.org.asc"

src_unpack() {
	use verify-sig && verify-sig_verify_detached "${DISTDIR}"/${P}-src.zip{,.asc}
	default
}

src_prepare() {
	default # bug #780585
	java-pkg-2_src_prepare
	sed -i "s/\${project.version}/${PV}/g" \
		"pdfbox/src/main/resources/org/apache/pdfbox/resources/version.properties" || die
}

src_compile() {
	einfo "Compiling pdfbox"
	JAVA_AUTOMATIC_MODULE_NAME="org.apache.pdfbox"
	JAVA_JAR_FILENAME="pdfbox.jar"
	JAVA_RESOURCE_DIRS="pdfbox/src/main/resources"
	JAVA_SRC_DIR="pdfbox/src/main/java"
	java-pkg-simple_src_compile
	rm -r target || die

	if use tools; then
		JAVA_GENTOO_CLASSPATH+=" commons-io picocli"
		einfo "Compiling debugger"
		JAVA_AUTOMATIC_MODULE_NAME="org.apache.pdfbox.debugger"
		JAVA_JAR_FILENAME="pdfbox-debugger.jar"
		JAVA_RESOURCE_DIRS="debugger/src/main/resources"
		JAVA_SRC_DIR="debugger/src/main/java"
		java-pkg-simple_src_compile
		rm -r target || die

		einfo "Compiling pdfbox-tools"
		JAVA_AUTOMATIC_MODULE_NAME="org.apache.pdfbox.tools"
		JAVA_JAR_FILENAME="pdfbox-tools.jar"
		JAVA_RESOURCE_DIRS=""
		JAVA_SRC_DIR="tools/src/main/java"
		java-pkg-simple_src_compile

		JAVADOC_SRC_DIRS+=( {debugger,tools}/src/main/java )
	fi

	JAVADOC_CLASSPATH="${JAVA_GENTOO_CLASSPATH}"
	use doc && ejavadoc
}

src_test() {
	einfo "Testing pdfbox"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/log4j-jcl-${L4J}.jar"

	# test-output is needed by some tests in
	# org.apache.pdfbox.pdmodel.interactive.form.PDAcroFormTest
	mkdir -p target/test-output || die

	mkdir -p src/test || die "mkdir"
	mv {pdfbox/,}src/test/resources || die "move resources"
	JAVA_TEST_RESOURCE_DIRS="src/test/resources"
	JAVA_TEST_SRC_DIR="pdfbox/src/test/java"

	mkdir target/{fonts,imgs,pdfs} || die
	cp \
		"${DISTDIR}"/PDFBOX-1031-1.pdf \
		"${DISTDIR}"/PDFBOX-1031-2.pdf \
		"${DISTDIR}"/PDFBOX-1065-1.pdf \
		"${DISTDIR}"/PDFBOX-1065-2.pdf \
		"${DISTDIR}"/PDFBOX-1100-1.pdf \
		"${DISTDIR}"/PDFBOX-1100-2.pdf \
		"${DISTDIR}"/PDFBOX-3656.pdf \
		"${DISTDIR}"/PDFBOX-3682.pdf \
		"${DISTDIR}"/PDFBOX-3940-079977.pdf \
		"${DISTDIR}"/PDFBOX-3785-202097.pdf \
		"${DISTDIR}"/PDFBOX-3947-670064.pdf \
		"${DISTDIR}"/PDFBOX-3948-EUWO6SQS5TM4VGOMRD3FLXZHU35V2CP2.pdf \
		"${DISTDIR}"/PDFBOX-3949-MKFYUGZWS3OPXLLVU2Z4LWCTVA5WNOGF.pdf \
		"${DISTDIR}"/PDFBOX-3950-23EGDHXSBBYQLKYOKGZUOVYVNE675PRD.pdf \
		"${DISTDIR}"/PDFBOX-3951-FIHUZWDDL2VGPOE34N6YHWSIGSH5LVGZ.pdf \
		"${DISTDIR}"/PDFBOX-3964-c687766d68ac766be3f02aaec5e0d713_2.pdf \
		"${DISTDIR}"/PDFBOX-3977-63NGFQRI44HQNPIPEJH5W2TBM6DJZWMI.pdf \
		"${DISTDIR}"/PDFBOX-3999-GeneralForbearance.pdf \
		"${DISTDIR}"/PDFBOX-4197.pdf \
		"${DISTDIR}"/PDFBOX-4308.pdf \
		"${DISTDIR}"/PDFBOX-4408.pdf \
		"${DISTDIR}"/PDFBOX-4418-000314.pdf \
		"${DISTDIR}"/PDFBOX-4418-000671.pdf \
		"${DISTDIR}"/PDFBOX-4423-000746.pdf \
		"${DISTDIR}"/PDFBOX-4517-cryptfilter.pdf \
		"${DISTDIR}"/PDFBOX-4750.pdf \
		"${DISTDIR}"/PDFBOX-4153-WXMDXCYRWFDCMOSFQJ5OAJIAFXYRZ5OA.pdf \
		"${DISTDIR}"/PDFBOX-4490.pdf \
		"${DISTDIR}"/PDFBOX-3208-L33MUTT2SVCWGCS6UIYL5TH3PNPXHIS6.pdf \
		"${DISTDIR}"/PDFBOX-3783-72GLBIGUC6LB46ELZFBARRJTLN4RBSQM.pdf \
		"${DISTDIR}"/PDFBOX-4338.pdf \
		"${DISTDIR}"/PDFBOX-4339.pdf \
		"${DISTDIR}"/genko_oc_shiryo1.pdf \
		"${DISTDIR}"/PDFBOX-4831.pdf \
		"${DISTDIR}"/PDFBOX-5025.pdf \
		"${DISTDIR}"/PDFBOX-5639.pdf \
		"${DISTDIR}"/PDFBOX-5742.pdf \
		"${DISTDIR}"/PDFBOX-5894.fdf \
		"${DISTDIR}"/PDFBOX-5927.pdf \
		"${DISTDIR}"/PDFBOX-5939-google-docs-1.pdf \
		"${DISTDIR}"/PDFBOX-5955-40bit.pdf \
		"${DISTDIR}"/PDFBOX-5955-48bit.pdf \
		"${DISTDIR}"/PDFBOX-6009.pdf \
		"target/pdfs" || die

	cp "${DISTDIR}"/n019003l.pfb "target/fonts" || die
	cp "${DISTDIR}"/PDFBOX-5484.ttf "target/fonts" || die
	unzip "${DISTDIR}"/ipag00303.zip -d "target/fonts" || die
	unzip "${DISTDIR}"/ipagp00303.zip -d "target/fonts" || die
	unzip "${DISTDIR}"/PDFBOX-515.zip -d "target/pdfs" || die

	cp \
		"${DISTDIR}"/PDFBOX-5196-lotus.jpg \
		"${DISTDIR}"/PDFBOX-4184-032163.jpg \
		"${DISTDIR}"/PDFBOX-4184-16bit.png \
		"target/imgs" || die

	junit5_src_test

	if use tools; then
		rm -r src/test/resources || die
		mv {tools/,}src/test/resources || die "move resources"
		einfo "Testing pdfbox-tools"
		JAVA_TEST_SRC_DIR="tools/src/test/java"
		JAVA_TEST_RESOURCE_DIRS="src/test/resources"
		junit5_src_test
	fi
}

src_install() {
	JAVA_JAR_FILENAME="pdfbox.jar"
	java-pkg-simple_src_install
	java-pkg_register-dependency bcutil

	if use tools; then
		java-pkg_dojar pdfbox-{debugger,tools}.jar
		java-pkg_dolauncher pdfbox --main org.apache.pdfbox.tools.PDFBox
	fi

	if use source; then
		java-pkg_dosrc \
			"${S}/pdfbox/src/main/java/*" \
			"${S}/debugger/src/main/java/*" \
			"${S}/tools/src/main/java/*"
	fi
}
