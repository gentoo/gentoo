# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/fop/fop-2.0-r1.ebuild,v 1.2 2015/07/19 08:33:32 monsieurp Exp $

# TODO: if 'doc' use flag is used then should build also extra docs ('docs' ant target), currently it cannot
#       be built as it needs forrest which we do not have
# TODO: package and use optional dependency jeuclid

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Formatting Objects Processor is a print formatter driven by XSL"
HOMEPAGE="http://xmlgraphics.apache.org/fop/"
SRC_URI="mirror://apache/xmlgraphics/${PN}/source/${P}-src.zip"

KEYWORDS="amd64 x86 ppc ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

# Tests are broken even in 2.0
RESTRICT="test"

CDEPEND="dev-java/batik:1.8
	dev-java/ant-core:0
	dev-java/fontbox:1.7
	dev-java/commons-io:1
	dev-java/commons-logging:0
	java-virtuals/servlet-api:3.0
	dev-java/avalon-framework:4.2
	dev-java/xmlgraphics-commons:2
	dev-java/xml-commons-external:1.3
	dev-java/qdox:1.12"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"

#	test? (
#		dev-java/ant-junit:0
#		dev-java/junit:4
#		dev-java/xmlunit:1
#		dev-java/mockito:0
#	)"

JAVA_ANT_ENCODING="ISO-8859-1"
JAVA_ANT_REWRITE_CLASSPATH="true"

EANT_GENTOO_CLASSPATH="
	ant-core
	batik-1.8
	fontbox-1.7
	commons-io-1
	commons-logging
	servlet-api-3.0
	avalon-framework-4.2
	xmlgraphics-commons-2
	xml-commons-external-1.3
"

TARGETS=(
	resourcegen
	jar-hyphenation
	jar-sandbox
	jar-main
)

java_prepare() {
	find "${S}"/lib -type f | xargs rm -v
}

src_compile() {
	# https://bugs.gentoo.org/show_bug.cgi?id=554386
	# http://wiki.apache.org/xmlgraphics-fop/HowTo/BuildFOPAlternatively
	java-pkg_jar-from --into lib qdox-1.12 qdox.jar
	java-pkg_jar-from --into lib xmlgraphics-commons-2 xmlgraphics-commons.jar
	java-pkg_jar-from --into lib commons-logging commons-logging.jar
	java-pkg_jar-from --into lib commons-io-1 commons-io.jar
	java-pkg_jar-from --into lib fontbox-1.7 fontbox.jar
	java-pkg_jar-from --into lib xml-commons-external-1.3 xml-apis-ext.jar
	java-pkg_jar-from --into lib xml-commons-external-1.3 xml-apis.jar
	java-pkg_jar-from --into lib avalon-framework-4.2 avalon-framework.jar
	java-pkg_jar-from --virtual --into lib servlet-api-3.0 servlet-api.jar

	for target in ${TARGETS[@]}; do
		EANT_BUILD_TARGET="${target}" \
			java-pkg-2_src_compile
	done

	if use doc; then
		sed -i -e 's/failonerror=\"true\"/failonerror=\"false\"/;' ./build.xml
		EANT_BUILD_TARGET="javadocs" \
			java-pkg-2_src_compile
	fi
}

src_install() {
	java-pkg_dojar \
		build/${PN}.jar \
		build/${PN}-sandbox.jar \
		build/${PN}-hyph.jar

	java-pkg_dolauncher ${PN} --main org.apache.fop.cli.Main

	dodoc NOTICE README

	if use doc; then
		java-pkg_dojavadoc \
			build/javadocs
	fi

	if use examples; then
		java-pkg_doexamples \
			examples/* conf
	fi

	if use source; then
		java-pkg_dosrc \
			src/java/org \
			src/sandbox/org
	fi
}
