# Copyright 1999-2023 Gentoo Authors
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
	https://dev.gentoo.org/~flow/distfiles/fop/fop-2.7-jars.tar.xz
	verify-sig? ( https://www.apache.org/dist/xmlgraphics/fop/source/${P}-src.tar.gz.asc )
	test? ( https://repo1.maven.org/maven2/net/sf/offo/fop-hyph/2.0/fop-hyph-2.0.jar )
"
S="${WORKDIR}/fop-${PV}"

LICENSE="Apache-2.0"
SLOT="2.8"
KEYWORDS="amd64 ~arm64 ppc64 x86"

CP_DEPEND="
	dev-java/batik:1.16
	dev-java/commons-io:1
	dev-java/commons-logging:0
	dev-java/fontbox:0
	dev-java/qdox:1.12
	dev-java/xmlgraphics-commons:2
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	dev-java/ant-core:0
	dev-java/javax-servlet-api:2.2
	dev-java/sun-jai-bin:0
	test? (
		dev-java/mockito:2
		dev-java/pdfbox:0
		dev-java/xmlunit:1
	)
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="dev-java/xalan:0"

DOCS=( NOTICE README )

PATCHES=( "${FILESDIR}/fop-2.8-skip-failing-tests.patch" )

JAVA_CLASSPATH_EXTRA="
	ant-core
	javax-servlet-api-2.2
	sun-jai-bin
"

BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-apache-xmlgraphics-fop )"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/xmlgraphics-fop.apache.org.asc"

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}-src.tar.gz{,.asc}
	fi
	default
}

src_prepare() {
	java-pkg_clean
	java-pkg-2_src_prepare
	default
}

src_compile() {
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
	java-pkg-simple_src_compile

	# Update "fop-core.jar" with "event-mode.xml" files produced manually
	# by running "mvn package".
	# Upstream does this with maven-antrun-plugin:
	# https://github.com/apache/xmlgraphics-fop/blob/fop-2_8/fop-core/pom.xml#L269-L290
	mkdir event-model && pushd $_ > /dev/null || die
		jar -xf "${WORKDIR}/fop-2.7-core-event-models.jar"
	popd > /dev/null || die

	jar -uf "fop-core.jar" -C event-model . || die
	JAVA_GENTOO_CLASSPATH_EXTRA+=":fop-core.jar"
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
	jar -xf "${WORKDIR}/fop-2.7-test-event-model.jar" || die
	java-pkg-simple_src_test

	einfo "Testing fop-core"
	pushd fop-core/src/test/java > /dev/null || die
		# Excluding one test, see https://bugs.gentoo.org/903880
		local JAVA_TEST_RUN_ONLY=$(find * -type f \
			-name "*TestCase.java" \
			! -name 'MissingLanguageWarningTestCase.java' \
			)
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
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
	java-pkg_dolauncher "fop-${SLOT}" --main "org.apache.fop.cli.Main"
	einstalldocs
}
