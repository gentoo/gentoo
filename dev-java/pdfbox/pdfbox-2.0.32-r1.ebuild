# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.pdfbox:pdfbox:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Java library and utilities for working with PDF documents"
HOMEPAGE="https://pdfbox.apache.org/"
SRC_URI="mirror://apache/${PN}/${PV}/${P}-src.zip
	test? (
		https://issues.apache.org/jira/secure/attachment/12481683/1.pdf -> PDFBOX-1031-1.pdf
		https://issues.apache.org/jira/secure/attachment/12481684/2.pdf -> PDFBOX-1031-2.pdf
		https://issues.apache.org/jira/secure/attachment/12486525/1_testfile1.pdf -> PDFBOX-1065-1.pdf
		https://issues.apache.org/jira/secure/attachment/12486526/2_testfile1.pdf -> PDFBOX-1065-2.pdf
		https://issues.apache.org/jira/secure/attachment/12490774/a.pdf -> PDFBOX-1100-1.pdf
		https://issues.apache.org/jira/secure/attachment/12490775/b.pdf -> PDFBOX-1100-2.pdf
		https://issues.apache.org/jira/secure/attachment/12848122/SF1199AEG%20%28Complete%29.pdf -> PDFBOX-3656.pdf
		https://issues.apache.org/jira/secure/attachment/12852207/test.pdf -> PDFBOX-3682.pdf
		https://issues.apache.org/jira/secure/attachment/12888957/079977.pdf -> PDFBOX-3940-079977.pdf
		https://issues.apache.org/jira/secure/attachment/12867113/202097.pdf -> PDFBOX-3785-202097.pdf
		https://issues.apache.org/jira/secure/attachment/12890031/670064.pdf -> PDFBOX-3947-670064.pdf
		https://issues.apache.org/jira/secure/attachment/12890034/EUWO6SQS5TM4VGOMRD3FLXZHU35V2CP2.pdf -> PDFBOX-3948-EUWO6SQS5TM4VGOMRD3FLXZHU35V2CP2.pdf
		https://issues.apache.org/jira/secure/attachment/12890037/MKFYUGZWS3OPXLLVU2Z4LWCTVA5WNOGF.pdf -> PDFBOX-3949-MKFYUGZWS3OPXLLVU2Z4LWCTVA5WNOGF.pdf
		https://issues.apache.org/jira/secure/attachment/12890042/23EGDHXSBBYQLKYOKGZUOVYVNE675PRD.pdf -> PDFBOX-3950-23EGDHXSBBYQLKYOKGZUOVYVNE675PRD.pdf
		https://issues.apache.org/jira/secure/attachment/12890047/FIHUZWDDL2VGPOE34N6YHWSIGSH5LVGZ.pdf -> PDFBOX-3951-FIHUZWDDL2VGPOE34N6YHWSIGSH5LVGZ.pdf
		https://issues.apache.org/jira/secure/attachment/12892097/c687766d68ac766be3f02aaec5e0d713_2.pdf -> PDFBOX-3964-c687766d68ac766be3f02aaec5e0d713_2.pdf
		https://issues.apache.org/jira/secure/attachment/12893582/63NGFQRI44HQNPIPEJH5W2TBM6DJZWMI.pdf -> PDFBOX-3977-63NGFQRI44HQNPIPEJH5W2TBM6DJZWMI.pdf
		https://issues.apache.org/jira/secure/attachment/12896905/GeneralForbearance.pdf -> PDFBOX-3999-GeneralForbearance.pdf
		https://issues.apache.org/jira/secure/attachment/12919726/sample.pdf -> PDFBOX-4197.pdf
		https://issues.apache.org/jira/secure/attachment/12938094/Quelldatei.pdf -> PDFBOX-4308.pdf
		https://issues.apache.org/jira/secure/attachment/12952086/form.pdf -> PDFBOX-4408.pdf
		https://issues.apache.org/jira/secure/attachment/12953423/000314.pdf -> PDFBOX-4418-000314.pdf
		https://issues.apache.org/jira/secure/attachment/12953421/000671.pdf -> PDFBOX-4418-000671.pdf
		https://issues.apache.org/jira/secure/attachment/12953866/000746.pdf -> PDFBOX-4423-000746.pdf
		https://issues.apache.org/jira/secure/attachment/12966453/cryptfilter.pdf -> PDFBOX-4517-cryptfilter.pdf
		https://issues.apache.org/jira/secure/attachment/12991833/PDFBOX-4750-test.pdf -> PDFBOX-4750.pdf
		https://issues.apache.org/jira/secure/attachment/12914331/WXMDXCYRWFDCMOSFQJ5OAJIAFXYRZ5OA.pdf -> PDFBOX-4153-WXMDXCYRWFDCMOSFQJ5OAJIAFXYRZ5OA.pdf
		https://issues.apache.org/jira/secure/attachment/12962991/NeS1078.pdf -> PDFBOX-4490.pdf
		https://issues.apache.org/jira/secure/attachment/12784025/PDFBOX-3208-L33MUTT2SVCWGCS6UIYL5TH3PNPXHIS6.pdf
		https://issues.apache.org/jira/secure/attachment/12867102/PDFBOX-3783-72GLBIGUC6LB46ELZFBARRJTLN4RBSQM.pdf
		https://issues.apache.org/jira/secure/attachment/12929821/16bit.png -> PDFBOX-4184-16bit.png
		https://issues.apache.org/jira/secure/attachment/12943502/ArrayIndexOutOfBoundsException%20COSParser -> PDFBOX-4338.pdf
		https://issues.apache.org/jira/secure/attachment/12943503/NullPointerException%20COSParser -> PDFBOX-4339.pdf
		https://issues.apache.org/jira/secure/attachment/12867433/genko_oc_shiryo1.pdf
		https://moji.or.jp/wp-content/ipafont/IPAfont/ipag00303.zip
		https://moji.or.jp/wp-content/ipafont/IPAfont/ipagp00303.zip
		https://issues.apache.org/jira/secure/attachment/12911053/n019003l.pfb
		https://issues.apache.org/jira/secure/attachment/12949710/032163.jpg -> PDFBOX-4184-032163.jpg
		https://issues.apache.org/jira/secure/attachment/13025718/lotus.jpg -> PDFBOX-5196-lotus.jpg
		https://issues.apache.org/jira/secure/attachment/13002695/13._Korona_szallo_vegzes_13.09.26.eredeti.pdf -> PDFBOX-4831.pdf
		https://issues.apache.org/jira/secure/attachment/13061409/incorrect_password.pdf -> PDFBOX-5639.pdf
	)
	verify-sig? ( https://downloads.apache.org/pdfbox/${PV}/pdfbox-${PV}-src.zip.asc )"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 arm64 ppc64"
IUSE="+tools"

PROPERTIES="test_network"
RESTRICT="test"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/pdfbox.apache.org.asc"
BDEPEND="
	app-arch/unzip
	verify-sig? ( sec-keys/openpgp-keys-apache-pdfbox )
"
CP_DEPEND="
	dev-java/bcmail:0
	dev-java/bcpkix:0
	dev-java/bcprov:0
	dev-java/bcutil:0
	dev-java/commons-logging:0
	~dev-java/fontbox-${PV}:2
"
DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/jai-imageio-core:0
		dev-java/jai-imageio-jpeg2000:0
		dev-java/java-diff-utils:0
		dev-java/jbig2-imageio:0
		dev-java/mockito:4
	)
"
RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( README.md {NOTICE,RELEASE-NOTES}.txt )

JAVA_GENTOO_CLASSPATH_EXTRA="pdfbox.jar:pdfbox-debugger.jar"
JAVA_TEST_GENTOO_CLASSPATH="jai-imageio-core,jai-imageio-jpeg2000,java-diff-utils,jbig2-imageio,junit-4,mockito-4"

JAVA_TEST_EXCLUDES=(
	# excluded upstream according to
	# https://github.com/apache/pdfbox/blob/2.0.27/pdfbox/pom.xml#L123
	"org.apache.pdfbox.rendering.TestPDFToImage"

	# Causing test failures. Upstream does not run these tests.
	"org.apache.pdfbox.cos.TestCOSBase"
	"org.apache.pdfbox.cos.TestCOSNumber"
)

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached \
			"${DISTDIR}/pdfbox-${PV}-src.zip" \
			"${DISTDIR}/pdfbox-${PV}-src.zip.asc"
	fi
	default
}

src_prepare() {
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
	fi

	if use doc; then
		einfo "Compiling javadocs"
		JAVA_SRC_DIR=(
			"${S}/pdfbox/src/main/java"
			"${S}/debugger/src/main/java"
		)
		if use tools; then
			JAVA_SRC_DIR+=( "${S}/tools/src/main/java" )
		fi
		JAVA_JAR_FILENAME="ignoreme.jar"
		java-pkg-simple_src_compile
	fi
}

src_test() {
	# @Ignore 2 tests which otherwise would fail
	# 'mvn test' skips them
	sed \
		-e '/import org.junit.Test/a import org.junit.Ignore;' \
		-e '/testPDFBox3826()/i @Ignore' \
		-e '/testPDFBox5484()/i @Ignore' \
		-i pdfbox/src/test/java/org/apache/pdfbox/pdmodel/font/PDFontTest.java || die

	einfo "Testing pdfbox"
	JAVA_TEST_SRC_DIR="pdfbox/src/test/java"
	JAVA_TEST_RESOURCE_DIRS="pdfbox/src/test/resources"

	# tests failed with S="${WORKDIR}/${P}"
	find pdfbox/src/test/ -type f -exec sed -i 's:src/test/resources:pdfbox/src/test/resources:' {} + || die

	mkdir --parents target/pdfs || die
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
		"${DISTDIR}"/PDFBOX-5639.pdf \
		"target/pdfs" || die

	mkdir target/fonts || die
	cp "${DISTDIR}"/n019003l.pfb "target/fonts" || die
	unzip "${DISTDIR}"/ipag00303.zip -d "target/fonts" || die
	unzip "${DISTDIR}"/ipagp00303.zip -d "target/fonts" || die

	mkdir target/imgs || die
	cp \
		"${DISTDIR}"/PDFBOX-5196-lotus.jpg \
		"${DISTDIR}"/PDFBOX-4184-032163.jpg \
		"${DISTDIR}"/PDFBOX-4184-16bit.png \
		"target/imgs" || die

	java-pkg-simple_src_test
	rm -r target/test-classes || die # avoid to run previous tests again

	if use tools; then
		einfo "Testing pdfbox-tools"
		find tools/src/test/ -type f -exec sed -i 's:src/test/resources:tools/src/test/resources:' {} + || die
		JAVA_TEST_SRC_DIR="tools/src/test/java"
		JAVA_TEST_RESOURCE_DIRS="tools/src/test/resources"
		java-pkg-simple_src_test
	fi
}

src_install() {
	default

	java-pkg_dojar "pdfbox.jar"
	if use tools; then
		java-pkg_dojar "pdfbox-debugger.jar"
		java-pkg_dojar "pdfbox-tools.jar"
		java-pkg_dolauncher ${PN}-${SLOT} --main org.apache.pdfbox.tools.PDFBox
	fi

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	if use source; then
		java-pkg_dosrc \
			"${S}/pdfbox/src/main/java/*" \
			"${S}/debugger/src/main/java/*" \
			"${S}/tools/src/main/java/*"
	fi
}
