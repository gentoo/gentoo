# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.xmlgraphics:fop:2.7"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XML Graphics Format Object Processor All-In-One"
HOMEPAGE="https://xmlgraphics.apache.org/fop/"
SRC_URI="mirror://apache/xmlgraphics/fop/source/fop-${PV}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2.7"
KEYWORDS="~amd64 ~ppc64 ~x86"

CP_DEPEND="
	dev-java/batik:1.14
	dev-java/commons-io:1
	dev-java/fontbox:0
	dev-java/qdox:1.12
	dev-java/sun-jai-bin:0
	dev-java/xmlgraphics-commons:2
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	dev-java/ant-core:0
	dev-java/sun-jai-bin:0
	test? (
		dev-java/mockito:0
		dev-java/pdfbox:0
		dev-java/xmlunit:1
	)
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( NOTICE README )

S="${WORKDIR}/fop-${PV}"

src_prepare() {
	default
	java-pkg_clean
}

src_compile() {
	JAVA_SRC_DIR="fop-util/src/main/java"
	JAVA_JAR_FILENAME="fop-util.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":fop-util.jar"
	rm -r target || die

	JAVA_SRC_DIR="fop-events/src/main/java"
	JAVA_RESOURCE_DIRS="fop-events/src/main/resources"
	JAVA_JAR_FILENAME="fop-events.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":fop-events.jar"
	rm -r target || die

	JAVA_SRC_DIR="fop-core/src/main/java"
	JAVA_RESOURCE_DIRS="fop-core/src/main/resources"
	JAVA_MAIN_CLASS=$( sed -n 's:.*<mainClass>\(.*\)</mainClass>:\1:p' fop-core/pom.xml )
	JAVA_JAR_FILENAME="fop-core.jar"
	# Code generation according to
	# https://github.com/apache/xmlgraphics-fop/blob/fop-2_7/fop-core/pom.xml#L150-L219
	pushd fop-core/src/main/codegen/fonts >/dev/null || die
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
	popd
	java-pkg-simple_src_compile
	rm -r target || die

	JAVA_GENTOO_CLASSPATH_EXTRA+=":fop-core.jar"

	# Update "fop-core.jar" with "event-mode.xml" files produced manually
	# by running "mvn package".
	mkdir event-model && pushd $_ >/dev/null || die
		jar -xf "${FILESDIR}/fop-2.7-core-event-models.jar"
	popd
	jar -uf "fop-core.jar" -C event-model . || die
	# Upstream does this with maven-antrun-plugin:
	# https://github.com/apache/xmlgraphics-fop/blob/fop-2_7/fop-core/pom.xml#L263-L284

	# public class EventProducerCollectorTask extends Task {
	#
	#     private List<FileSet> filesets = new java.util.ArrayList<FileSet>();
	#     private File destDir;
	#     private File translationFile;

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
	JAVA_TEST_GENTOO_CLASSPATH="junit-4,mockito,pdfbox,xmlunit-1"

	JAVA_TEST_SRC_DIR="fop-events/src/test/java"
	JAVA_TEST_RUN_ONLY="org.apache.fop.events.BasicEventTestCase"

	# This jar file was created manually from the output of "mvn test".
	# Upstream does this with maven-antrun-plugin
	jar -xf ${FILESDIR}/fop-2.7-test-event-model.jar || die

	java-pkg-simple_src_test

	JAVA_TEST_SRC_DIR="fop-core/src/test/java"
	JAVA_TEST_RESOURCE_DIRS="fop-core/src/test/resources"

	# Testing fop-core seems to want a newer mockito:
	# error: cannot find symbol
	# import static org.mockito.ArgumentMatchers.anyInt;
#	java-pkg-simple_src_test
}

src_install() {
	for module in fop-util fop-events fop-core ; do
		java-pkg_dojar $module.jar
		if use source; then
			java-pkg_dosrc "$module/src/main/java/*"
		fi
	done
	if use doc; then
		java-pkg_dojavadoc target/api
	fi
	java-pkg_dolauncher "fop-${SLOT}" --main "org.apache.fop.cli.Main"
	einstalldocs
}
