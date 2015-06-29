# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/fop/fop-2.0.ebuild,v 1.9 2015/06/29 12:33:34 monsieurp Exp $

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
IUSE="hyphenation jai"
LICENSE="Apache-2.0"
SLOT="2"

MY_P="${PN}-${SLOT}"

# Tests are broken even in 2.0
RESTRICT="test"

CDEPEND="
	dev-java/batik:1.8
	dev-java/ant-core:0
	dev-java/fontbox:1.7
	dev-java/commons-io:1
	dev-java/commons-logging:0
	java-virtuals/servlet-api:3.0
	dev-java/avalon-framework:4.2
	dev-java/xmlgraphics-commons:2
	dev-java/xml-commons-external:1.3
	dev-java/qdox:1.12
	jai? ( dev-java/sun-jai-bin:0 )"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	hyphenation? ( dev-java/offo-hyphenation:0 )
	app-arch/unzip
	${CDEPEND}
	test? (
		dev-java/ant-junit:0
		dev-java/junit:4
		dev-java/xmlunit:1
		dev-java/mockito:0
	)"

java_prepare() {
	find "${S}" -name '*.jar' -print -delete || die
}

JAVA_ANT_ENCODING="ISO-8859-1"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_DOC_TARGET="javadocs"
EANT_BUILD_TARGET="package"
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

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH}
	mockito
	junit-4
	xmlunit-1
"

EANT_EXTRA_ARGS="-Djce.present=true"
EANT_DOC_TARGET="javadocs"
EANT_TEST_TARGET="junit"
#EANT_TEST_EXTRA_ARGS="-Djunit.present=true -Dxmlunit.present=true"

src_compile() {
	EANT_GENTOO_CLASSPATH_EXTRA+="$(java-pkg_getjars --build-only qdox-1.12)"

	if use jai; then
		EANT_EXTRA_ARGS+=" -Djai.present=true"
		EANT_GENTOO_CLASSPATH+=" sun-jai-bin"
	fi

	if use hyphenation; then
		EANT_EXTRA_ARGS+=" -Dhyphenation.present=true -Duser.hyph.dir=${EPREFIX}/usr/share/offo-hyphenation/hyph/"
	fi

	java-pkg-2_src_compile
}

# Tests are broken even in 2.0
src_test() {
	EANT_ANT_TASKS="ant-junit" \
		java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar build/${PN} build/${PN}-sandbox.jar

	if use hyphenation; then
		java-pkg_dojar build/${PN}-hyph.jar
		insinto /usr/share/${MY_P}/
		doins -r hyph
	fi

	# Doesn't support everything upstream launcher does...
	java-pkg_dolauncher ${MY_P} --main org.apache.fop.cli.Main

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
