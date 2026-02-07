# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="XML Graphics Format Object Processor All-In-One"
HOMEPAGE="https://xmlgraphics.apache.org/fop/"
SRC_URI="
	mirror://apache/xmlgraphics/fop/source/${P}-src.tar.gz
	verify-sig? ( mirror://apache/xmlgraphics/fop/source/${P}-src.tar.gz.asc )
	test? ( https://repo1.maven.org/maven2/net/sf/offo/fop-hyph/2.0/fop-hyph-2.0.jar )
"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

BDEPEND="
	>=dev-java/xalan-2.7.3-r3:0
	verify-sig? ( sec-keys/openpgp-keys-apache-xmlgraphics )
"

CP_DEPEND="
	>=dev-java/ant-1.10.15-r1:0
	~dev-java/batik-1.19:0
	>=dev-java/bcpkix-1.84:0
	>=dev-java/bcprov-1.84:0
	>=dev-java/bcutil-1.84:0
	dev-java/commons-io:1
	>=dev-java/commons-logging-1.3.6:0
	>=dev-java/fontbox-3.0.6:0
	dev-java/jakarta-servlet-api:6.1
	dev-java/qdox:1.12
	dev-java/sun-jai-bin:0
	dev-java/xml-commons-external:1.4
	~dev-java/xmlgraphics-commons-2.11:0
"

# Min jdk-11 in order to avoid test failures like:
# java.lang.NoSuchMethodError: java.nio.ByteBuffer.position(I)Ljava/nio/ByteBuffer;
DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*
	test? (
		dev-java/mockito:2
		>=dev-java/pdfbox-3.0.6:0
		dev-java/xmlunit:1
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( NOTICE README )
PATCHES=(
	"${FILESDIR}/fop-2.9-PDFEncodingTestCase.patch"
	"${FILESDIR}/fop-2.11-PDFDocumentInformationElementTestCase.patch"
	"${FILESDIR}/fop-2.11-PDFLinearizationTestCase.patch"
	"${FILESDIR}/fop-2.11-PDFStructureTreeTestCase.patch"
)

JAVADOC_SRC_DIRS=( fop-{util,events,core}/src/main/java )
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/apache-xmlgraphics.asc"

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}-src.tar.gz{,.asc}
	fi
	unpack ${P}-src.tar.gz
}

src_prepare() {
	java-pkg_clean
	java-pkg-2_src_prepare

	einfo "prepare fop-events/build-gentoo.xml"
	# ant-task to create "event-model.xml" file directly into fop-events/src/test/resources
	local extract_events="$(sed -n '/taskdef/,/\/collectEvents/p' fop-events/pom.xml |
		sed -e 's:${project.basedir}\/::' \
			-e 's:${project.build.testOutputDirectory}:src/test/resources:' \
			-e '/maven.test.classpath/d' |
		cut -d' ' -f 15-25 ; pipestatus || die)"
	# The first three lines are manually copied headers needed for a build.xml
	# but are not given in the pom.xml.
	# The 'path' element, also not from the pom.xml, creates the classpath
	# needed to run this ant-task using eant().
	cat <<- FOP-EVENTS > fop-events/build-gentoo.xml || die "FOP-EVENTS"
		<?xml version="1.0" encoding="UTF-8" ?>
		<project default="main">
		<target name="main">
		<path id="maven.compile.classpath">
			<fileset dir="../">
				<include name="commons-io.jar"/>
				<include name="fop-events.jar"/>
				<include name="qdox.jar"/>
				<include name="xmlgraphics-commons.jar"/>
			</fileset>
		</path>
		${extract_events}
		</target>
		</project>
	FOP-EVENTS

	einfo "prepare fop-core/build-gentoo.xml"
	# ant-task to create "event-model.xml" files directly into target/classes
	local extract_core="$(sed -n '/taskdef/,/\/collectEvents/p' fop-core/pom.xml |
		sed -e 's:${project.basedir}\/::' \
			-e 's:${project.build.outputDirectory}:../target/classes:' |
		cut -d' ' -f 15-25 ; pipestatus || die)"
	# The first three lines are manually copied headers needed for a build.xml
	# but are not given in the pom.xml.
	# The 'path' element, also not from the pom.xml, creates the classpath
	# needed to run this ant-task using eant().
	cat <<- FOP-CORE > fop-core/build-gentoo.xml || die "FOP-CORE"
		<?xml version="1.0" encoding="UTF-8" ?>
		<project default="main">
		<target name="main">
		<path id="maven.compile.classpath">
			<fileset dir="../">
				<include name="commons-io.jar"/>
				<include name="commons-logging.jar"/>
				<include name="fop-core.jar"/>
				<include name="fop-events.jar"/>
				<include name="qdox.jar"/>
				<include name="xmlgraphics-commons.jar"/>
			</fileset>
		</path>
		${extract_core}
		</target>
		</project>
	FOP-CORE

	einfo "generate Java code according to fop-core/pom.xml lines 172-243"
	local fonts=$(find fop-core/src/main/codegen/fonts \( -name "Courier*.xml" \
		-o -name "Helvetica*.xml" \
		-o -name "Times*.xml" \
		-o -name "Symbol.xml" \
		-o -name "ZapfDingbats.xml" \) -printf '%P\n'
	)
	cd fop-core/src/main/codegen/fonts || die "change dir"
	for font in ${fonts}; do
		xalan -XSLTC \
			-IN $font \
			-XSL font-file.xsl \
			-OUT ../../java/org/apache/fop/fonts/base14/${font//.xml}.java || die
	done

	xalan -XSLTC \
		-IN encodings.xml \
		-XSL code-point-mapping.xsl \
		-OUT ../../java/org/apache/fop/fonts/base14/CodePointMapping.java || die
}

src_compile() {
	# while ant could install multiple jar files we only need ant.jar
	JAVA_GENTOO_CLASSPATH_EXTRA=":$(java-pkg_getjar --build-only ant ant.jar)"

	JAVA_AUTOMATIC_MODULE_NAME="org.apache.xmlgraphics.fop.util"
	JAVA_JAR_FILENAME="fop-util.jar"
	JAVA_SRC_DIR="fop-util/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":fop-util.jar"
	rm -r target || die

	JAVA_AUTOMATIC_MODULE_NAME="org.apache.xmlgraphics.fop.events"
	JAVA_JAR_FILENAME="fop-events.jar"
	JAVA_RESOURCE_DIRS="fop-events/src/main/resources"
	JAVA_SRC_DIR="fop-events/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":fop-events.jar"
	rm -r target || die

	JAVA_AUTOMATIC_MODULE_NAME="org.apache.xmlgraphics.fop.core"
	JAVA_JAR_FILENAME="fop-core.jar"
	JAVA_MAIN_CLASS=$( sed -n 's:.*<mainClass>\(.*\)</mainClass>:\1:p' fop-core/pom.xml )
	JAVA_RESOURCE_DIRS="fop-core/src/main/resources"
	JAVA_SRC_DIR="fop-core/src/main/java"

	java-pkg-simple_src_compile

	java-pkg_jar-from commons-io-1,commons-logging,qdox-1.12,xmlgraphics-commons
	eant -f fop-core/build-gentoo.xml # this creates the *event-model.xml files
	jar cf fop-core.jar -C target/classes . || die "add event-model.xml files"

	JAVADOC_CLASSPATH="${JAVA_GENTOO_CLASSPATH}"
	use doc && ejavadoc
}

src_test() {
	JAVA_TEST_GENTOO_CLASSPATH="junit-4,mockito-2,pdfbox,xmlunit-1"

	einfo "Testing fop-events"
	JAVA_TEST_EXCLUDES="org.apache.fop.events.TestEventProducer"
	JAVA_TEST_RESOURCE_DIRS=( fop-events/src/test/resources )
	JAVA_TEST_SRC_DIR=( fop-events/src/test/java )
	mkdir fop-events/src/test/resources || die "mkdir events"
	eant -f fop-events/build-gentoo.xml # this creates the *event-model.xml file
	java-pkg-simple_src_test

	einfo "Building the core-test.jar"
	cd fop || die "cd fop" # fop-core/pom.xml line 322
	JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/fop-hyph-2.0.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":../fop-util.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":../fop-events.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":../fop-core.jar"
	JAVA_JAR_FILENAME="core-test.jar"
	JAVA_RESOURCE_DIRS=( ../fop-core/src/test/resources )
	JAVA_SRC_DIR=( ../fop-core -path */src/test/java/**.java )
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":core-test.jar"

	einfo "Testing fop-core"
	JAVA_TEST_RESOURCE_DIRS=( ../fop-core/src/test/resources )
	# **TestCase.java according to fop-core/pom.xml line 319
	JAVA_TEST_SRC_DIR=( ../fop-core -path */src/test/java/**TestCase.java )
	java-pkg-simple_src_test
}

src_install() {
	java-pkg_dojar fop-{util,events}.jar # omit fop-core.jar
	JAVA_JAR_FILENAME="fop-core.jar" # it will be installed by the eclass
	JAVA_SRC_DIR=( fop-{util,events,core}/src/main/java ) # for 'use source'
	java-pkg-simple_src_install
	java-pkg_dolauncher "fop" --main "org.apache.fop.cli.Main"
}
