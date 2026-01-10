# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.xmlgraphics:fop:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="XML Graphics Format Object Processor All-In-One"
HOMEPAGE="https://xmlgraphics.apache.org/fop/"
SRC_URI="
	mirror://apache/xmlgraphics/fop/source/${P}-src.tar.gz
	https://dev.gentoo.org/~fordfrog/distfiles/fop-2.10-jars.tar.xz
	verify-sig? ( https://downloads.apache.org/xmlgraphics/fop/source/${P}-src.tar.gz.asc )
	test? ( https://repo1.maven.org/maven2/net/sf/offo/fop-hyph/2.0/fop-hyph-2.0.jar )
"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/xmlgraphics-fop.apache.org.asc"

BDEPEND="
	dev-java/xalan:0
	verify-sig? ( sec-keys/openpgp-keys-apache-xmlgraphics-fop )
"

CP_DEPEND="
	>=dev-java/ant-1.10.14-r3:0
	dev-java/batik:0
	dev-java/bcprov:0
	dev-java/bcpkix:0
	dev-java/commons-io:1
	dev-java/commons-logging:0
	>=dev-java/fontbox-2.0.32-r1:2
	dev-java/jakarta-servlet-api:6.1
	dev-java/qdox:1.12
	dev-java/sun-jai-bin:0
	dev-java/xmlgraphics-commons:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/mockito:2
		>=dev-java/pdfbox-2.0.32-r1:2
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
	"${FILESDIR}/fop-2.10-java23.patch"
)

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}-src.tar.gz{,.asc}
	fi
	default
}

src_prepare() {
	java-pkg_clean
	default #780585
	java-pkg-2_src_prepare
}

src_compile() {
	# while ant could install multiple jar files we only need ant.jar
	JAVA_GENTOO_CLASSPATH_EXTRA=":$(java-pkg_getjar ant ant.jar)"

	JAVA_JAR_FILENAME="fop-util.jar"
	JAVA_SRC_DIR="fop-util/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":fop-util.jar"
	rm -r target || die

	JAVA_JAR_FILENAME="fop-events.jar"
	JAVA_RESOURCE_DIRS="fop-events/src/main/resources"
	JAVA_SRC_DIR="fop-events/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":fop-events.jar"
	rm -r target || die

	JAVA_JAR_FILENAME="fop-core.jar"
	JAVA_MAIN_CLASS=$( sed -n 's:.*<mainClass>\(.*\)</mainClass>:\1:p' fop-core/pom.xml )
	JAVA_RESOURCE_DIRS="fop-core/src/main/resources"
	JAVA_SRC_DIR="fop-core/src/main/java"
	# Code generation according to
	# https://github.com/apache/xmlgraphics-fop/blob/fop-2_8/fop-core/pom.xml#L156-L225
	pushd fop-core/src/main/codegen/fonts > /dev/null || die
		local fonts=$(find . -name "Courier*.xml" \
			-o -name "Helvetica*.xml" \
			-o -name "Times*.xml" \
			-o -name "Symbol.xml" \
			-o -name "ZapfDingbats.xml"
			)
		for font in ${fonts}; do \
			xalan -XSLTC \
				-IN $font \
				-XSL font-file.xsl \
				-OUT ../../java/org/apache/fop/fonts/base14/${font//.xml}.java || die
		done
		xalan -XSLTC \
			-IN encodings.xml \
			-XSL code-point-mapping.xsl \
			-OUT ../../java/org/apache/fop/fonts/base14/CodePointMapping.java || die
	popd > /dev/null || die

	# Update JAVA_RESOURCE_DIRS with "event-mode.xml" files
	# produced manually by running "mvn package".
	# Upstream does this with maven-antrun-plugin, fop-core/pom.xml lines 285-308
	pushd "${JAVA_RESOURCE_DIRS}" > /dev/null || die
		jar -xf "${WORKDIR}/fop-2.10-core-event-models.jar"
	popd > /dev/null || die

#	einfo "Code generation according to fop-events/pom.xml lines 80-92"
#	mkdir -p test/java || die
#	mkdir -p fop-core/target/classes || die
#	local cp=fop-events.jar:"$(java-pkg_getjar ant ant.jar):$(java-pkg_getjars qdox-1.12)"
#	"$(java-config -J)" -cp "${cp}" \
#		org.apache.fop.eventtools.EventProducerCollectorTask \
#		fop-core/target/classes \
#		fop-core/src/main/java/org/apache/fop/afp/AFPEventProducer.java || die

	java-pkg-simple_src_compile

	rm -r target || die

	if use doc; then \
		JAVA_SRC_DIR=(
			"fop-util/src/main/java"
			"fop-events/src/main/java"
			"fop-core/src/main/java"
		)
		JAVA_JAR_FILENAME="ignoreme.jar"
		java-pkg-simple_src_compile
	fi
}

src_test() {
	JAVA_TEST_GENTOO_CLASSPATH="junit-4,mockito-2,pdfbox,xmlunit-1"

	einfo "Testing fop-events"
	JAVA_TEST_EXCLUDES="org.apache.fop.events.TestEventProducer"
	JAVA_TEST_SRC_DIR="fop-events/src/test/java"
	# This jar file was created manually from the output of "mvn test".
	# Upstream does this with maven-antrun-plugin
	jar -xf "${WORKDIR}/fop-2.10-test-event-model.jar" || die
	mkdir generated-test || die
	mv {target/test-classes,generated-test}/org || die
	java-pkg-simple_src_test

	einfo "Testing fop-core"
	pushd fop-core/src/test/java > /dev/null || die
		# Excluding one test, see https://bugs.gentoo.org/903880
		local JAVA_TEST_RUN_ONLY=$(find * -type f \
			-name "*TestCase.java" \
			)
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
		local vm_version="$(java-config -g PROVIDES_VERSION)"
		# these tests would fail with java.lang.NoSuchMethodError if compiled with jdk-1.8
		if ver_test "${vm_version}" -eq "1.8"; then
			JAVA_TEST_RUN_ONLY=${JAVA_TEST_RUN_ONLY//org.apache.fop.render.pdf.PDFEncodingTestCase}
			JAVA_TEST_RUN_ONLY=${JAVA_TEST_RUN_ONLY//org.apache.fop.fonts.truetype.OTFToType1TestCase}
#			org.apache.fop.render.pdf.PDFEncodingTestCase
#			org.apache.fop.fonts.truetype.OTFToType1TestCase
		fi
	popd > /dev/null || die
	# https://github.com/apache/xmlgraphics-fop/blob/fop-2_8/fop-core/pom.xml#L297-L307
	# <workingDirectory>../fop</workingDirectory>
	pushd fop > /dev/null || die
		JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/fop-hyph-2.0.jar"
		JAVA_GENTOO_CLASSPATH_EXTRA+=":../fop-util.jar"
		JAVA_GENTOO_CLASSPATH_EXTRA+=":../fop-events.jar"
		JAVA_GENTOO_CLASSPATH_EXTRA+=":../fop-core.jar"
		JAVA_TEST_RESOURCE_DIRS="../fop-core/src/test/resources"
		JAVA_TEST_SRC_DIR="../fop-core/src/test/java"
		java-pkg-simple_src_test
	popd > /dev/null || die
}

src_install() {
	local module
	for module in fop-util fop-events fop-core ; do
		java-pkg_dojar "${module}.jar"
		if use source; then
			java-pkg_dosrc "${module}/src/main/java/*"
		fi
	done
	if use doc; then
		java-pkg_dojavadoc target/api
	fi
	java-pkg_dolauncher "fop" --main "org.apache.fop.cli.Main"
	einstalldocs
}
