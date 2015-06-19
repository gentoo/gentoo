# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/fop/fop-1.1.ebuild,v 1.2 2014/08/10 20:13:16 slyfox Exp $

# TODO: if 'doc' use flag is used then should build also extra docs ('docs' ant target), currently it cannot
#       be built as it needs forrest which we do not have
# TODO: package and use optional dependency jeuclid

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"
WANT_ANT_TASKS="ant-trax"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Formatting Objects Processor is a print formatter driven by XSL"
HOMEPAGE="http://xmlgraphics.apache.org/fop/"
SRC_URI="mirror://apache/xmlgraphics/${PN}/source/${P}-src.zip"

KEYWORDS="~amd64 ~x86 ~ppc ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="hyphenation jai"
LICENSE="Apache-2.0"
SLOT="0"

# Doesn't work with java.awt.headless, requires Mockito.
RESTRICT="test"

COMMON_DEPEND="
	dev-java/avalon-framework:4.2
	dev-java/batik:1.7
	dev-java/commons-io:1
	dev-java/commons-logging:0
	java-virtuals/servlet-api:2.2
	dev-java/xmlgraphics-commons:1.5
	dev-java/xml-commons-external:1.3
	dev-java/ant-core:0
	jai? ( dev-java/sun-jai-bin )"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.5
	dev-java/qdox:1.12
	hyphenation? ( dev-java/offo-hyphenation )
	app-arch/unzip
	${COMMON_DEPEND}
	test? (
		dev-java/junit:4
		dev-java/xmlunit
	)"

java_prepare() {
	find "${S}" -name '*.jar' -print -delete || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_DOC_TARGET="javadocs"
EANT_BUILD_TARGET="package"
EANT_GENTOO_CLASSPATH="ant-core,avalon-framework-4.2,batik-1.7,servlet-api-2.2,commons-io-1,commons-logging,xmlgraphics-commons-1.5,xml-commons-external-1.3"
EANT_EXTRA_ARGS="-Djce.present=true"
EANT_DOC_TARGET="javadocs"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"
EANT_TEST_TARGET="junit"
EANT_TEST_EXTRA_ARGS="-Djunit.present=true -Dxmlunit.present=true"

src_compile() {
	EANT_GENTOO_CLASSPATH_EXTRA+="$(java-pkg_getjars --build-only qdox-1.12)"

	use jai && EANT_EXTRA_ARGS+=" -Djai.present=true" && EANT_GENTOO_CLASSPATH+=",sun-jai-bin"
	use hyphenation && EANT_EXTRA_ARGS+=" -Dhyphenation.present=true -Duser.hyph.dir=${EPREFIX}/usr/share/offo-hyphenation/hyph/"

	java-pkg-2_src_compile
}

src_test() {
	ANT_TASKS="ant-junit" java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar build/fop.jar build/fop-sandbox.jar

	if use hyphenation ; then
		java-pkg_dojar build/fop-hyph.jar
		insinto /usr/share/${PN}/
		doins -r hyph
	fi

	# Doesn't support everything upstream launcher does...
	java-pkg_dolauncher ${PN} --main org.apache.fop.cli.Main

	dodoc NOTICE README

	use doc && java-pkg_dojavadoc build/javadocs
	use examples && java-pkg_doexamples examples/* conf
	use source && java-pkg_dosrc src/java/org src/sandbox/org
}
