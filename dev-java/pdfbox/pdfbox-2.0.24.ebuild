# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pdfbox-2.0.24/pdfbox/pom.xml --download-uri https://downloads.apache.org/pdfbox/2.0.24/pdfbox-2.0.24-src.zip --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild pdfbox-2.0.24.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.pdfbox:pdfbox:2.0.24"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

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
	)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="+tools"

PROPERTIES="test_network"
RESTRICT="test"

# Common dependencies
# POM: ${P}/${PN}/pom.xml
# commons-logging:commons-logging:1.2 -> >=dev-java/commons-logging-1.2:0
# org.apache.pdfbox:fontbox:2.0.24 -> >=dev-java/fontbox-2.0.24:0
# org.bouncycastle:bcmail-jdk15on:1.64 -> >=dev-java/bcmail-1.68:0
# org.bouncycastle:bcprov-jdk15on:1.64 -> >=dev-java/bcprov-1.68:0

CDEPEND="
	dev-java/bcmail:0
	dev-java/bcprov:0
	dev-java/commons-logging:0
	~dev-java/fontbox-${PV}:0
	tools? (
		dev-java/java-diff-utils:0
		dev-java/junit:4
		dev-java/mockito:0
	)"

# Compile dependencies
# POM: ${P}/${PN}/pom.xml
# test? com.github.jai-imageio:jai-imageio-core:1.4.0 -> >=dev-java/jai-imageio-core-1.4.0:0
# test? com.github.jai-imageio:jai-imageio-jpeg2000:1.4.0 -> >=dev-java/jai-imageio-jpeg2000-1.4.0:0
# test? com.googlecode.java-diff-utils:diffutils:1.3.0 -> >=dev-java/java-diff-utils-1.3.0:0
# test? junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4
# test? org.apache.pdfbox:jbig2-imageio:3.0.3 -> >=dev-java/jbig2-imageio-3.0.3:0
# test? org.mockito:mockito-core:3.10.0 -> !!!suitble-mavenVersion-not-found!!!

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/jai-imageio-core:0
		dev-java/jai-imageio-jpeg2000:0
		dev-java/java-diff-utils:0
		dev-java/jbig2-imageio:0
		dev-java/mockito:0
	)"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="app-arch/unzip"

DOCS=( {README.md,{LICENSE,NOTICE,RELEASE-NOTES}.txt} )

PATCHES=(
	# adds @Ignore annotation to
	# public void testPDFBox3826() throws IOException, URISyntaxException
	# https://issues.apache.org/jira/browse/PDFBOX-3826
	"${FILESDIR}"/2.0.24-tests-ignore.patch
)

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH_EXTRA="pdfbox.jar:pdfbox-debugger.jar"
JAVA_GENTOO_CLASSPATH="commons-logging,fontbox,bcmail,bcprov"
JAVA_TEST_GENTOO_CLASSPATH="jai-imageio-core,jai-imageio-jpeg2000,java-diff-utils,jbig2-imageio,junit-4,mockito"

JAVA_TEST_EXCLUDES=(
	# excluded upstream according to
	# https://github.com/apache/pdfbox/blob/8876e8e1a0adbf619cef4638cc3cea073e3ca484/pdfbox/pom.xml#L123
	"org.apache.pdfbox.rendering.TestPDFToImage"

	# 1) warning(junit.framework.TestSuite$1)
	# junit.framework.AssertionFailedError: Cannot instantiate test case: testIsSetDirect (java.lang.InstantiationException
	# 2) warning(junit.framework.TestSuite$1
	# junit.framework.AssertionFailedError: Cannot instantiate test case: testAccept (java.lang.InstantiationException
	# 3) warning(junit.framework.TestSuite$1)
	# junit.framework.AssertionFailedError: Cannot instantiate test case: testGetCOSObject (java.lang.InstantiationException
	"org.apache.pdfbox.cos.TestCOSBase"

	# 4) warning(junit.framework.TestSuite$1)
	# junit.framework.AssertionFailedError: Cannot instantiate test case: testFloatValue (java.lang.InstantiationException
	# 5) warning(junit.framework.TestSuite$1)
	# junit.framework.AssertionFailedError: Cannot instantiate test case: testGet (java.lang.InstantiationException
	# 6) warning(junit.framework.TestSuite$1)
	# junit.framework.AssertionFailedError: Cannot instantiate test case: testInvalidNumber (java.lang.InstantiationException
	# 7) warning(junit.framework.TestSuite$1)
	# junit.framework.AssertionFailedError: Cannot instantiate test case: testLongValue (java.lang.InstantiationException
	# 8) warning(junit.framework.TestSuite$1)
	# junit.framework.AssertionFailedError: Cannot instantiate test case: testIntValue (java.lang.InstantiationException
	# 9) warning(junit.framework.TestSuite$1)
	# junit.framework.AssertionFailedError: Cannot instantiate test case: testLargeNumber (java.lang.InstantiationException
	# 10) warning(junit.framework.TestSuite$1)
	# junit.framework.AssertionFailedError: Cannot instantiate test case: testDoubleValue (java.lang.InstantiationException
	# 11) warning(junit.framework.TestSuite$1)
	# junit.framework.AssertionFailedError: Cannot instantiate test case: testIsSetDirect (java.lang.InstantiationException
	# 12) warning(junit.framework.TestSuite$1)
	# junit.framework.AssertionFailedError: Cannot instantiate test case: testAccept (java.lang.InstantiationException
	# 13) warning(junit.framework.TestSuite$1)
	# junit.framework.AssertionFailedError: Cannot instantiate test case: testGetCOSObject (java.lang.InstantiationException
	"org.apache.pdfbox.cos.TestCOSNumber"	# Tests run: 10,  Failures: 10
)

src_prepare() {
	default
}

src_compile() {
	JAVA_SRC_DIR="pdfbox/src/main/java"
	JAVA_RESOURCE_DIRS="pdfbox/src/main/resources"
	JAVA_JAR_FILENAME="pdfbox.jar"
	java-pkg-simple_src_compile

	JAVA_SRC_DIR="debugger/src/main/java"
	JAVA_RESOURCE_DIRS="debugger/src/main/resources"
	JAVA_JAR_FILENAME="pdfbox-debugger.jar"
	java-pkg-simple_src_compile

	if use tools; then
		JAVA_GENTOO_CLASSPATH+=" java-diff-utils,junit-4,mockito"
		JAVA_SRC_DIR="tools/src/main/java"
		JAVA_RESOURCE_DIRS=""
		JAVA_JAR_FILENAME="pdfbox-tools.jar"
		java-pkg-simple_src_compile
	fi

	JAVA_SRC_DIR=(
		"${S}/pdfbox"
		"${S}/debugger"
	)
	if use tools; then
		JAVA_SRC_DIR+=( "${S}/tools" )
	fi
	JAVA_JAR_FILENAME="ignoreme.jar"
	java-pkg-simple_src_compile
}

src_test() {
	JAVA_TEST_SRC_DIR="pdfbox/src/test/java"
	JAVA_TEST_RESOURCE_DIRS="pdfbox/src/test/resources"

	# There was 1 failure
	# 1) testIsEmbeddingPermittedMultipleVersions(org.apache.pdfbox.pdmodel.font.TestFontEmbedding)
	# java.lang.ExceptionInInitializerError
	# Caused by: java.lang.reflect.InaccessibleObjectException: Unable to make protected final java.lang.Class java.lang.ClassLoader.defineClass(java.lang.String,byte[],int,int,java.security.ProtectionDomain) throws java.lang.ClassFormatError accessible: module java.base does not "opens java.lang" to unnamed module @4dc690f9
	# FAILURES!!!
	# Tests run: 586,  Failures: 1
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if [[ "${vm_version}" == "17" ]] ; then
		JAVA_TEST_EXCLUDES+=( "org.apache.pdfbox.pdmodel.font.TestFontEmbedding" )
	fi

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
		find tools/src/test/ -type f -exec sed -i 's:src/test/resources:tools/src/test/resources:' {} + || die
		JAVA_TEST_SRC_DIR="tools/src/test/java"
		JAVA_TEST_RESOURCE_DIRS="tools/src/test/resources"
		java-pkg-simple_src_test
	fi
}

src_install() {
	# https://bugs.gentoo.org/789582
	default

	java-pkg_dojar "pdfbox.jar"
	java-pkg_dojar "pdfbox-debugger.jar"
	if use tools; then
		java-pkg_dojar "pdfbox-tools.jar"
		java-pkg_dolauncher ${PN} --main org.apache.pdfbox.tools.PDFBox
	fi

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	if use source; then
		java-pkg_dosrc "${S}/pdfbox" "${S}/debugger" "${S}/tools"
	fi
}
