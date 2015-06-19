# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/fop/fop-0.95.ebuild,v 1.7 2012/10/18 08:40:33 ottxor Exp $

# TODO: if 'doc' use flag is used then should build also extra docs ('docs' ant target), currently it cannot
#       be built as it needs forrest which we do not have
# TODO: package and use optional dependency jeuclid

EAPI=4
JAVA_PKG_IUSE="doc examples source"
WANT_ANT_TASKS="ant-trax"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Formatting Objects Processor is a print formatter driven by XSL"
HOMEPAGE="http://xmlgraphics.apache.org/fop/"
SRC_URI="mirror://apache/xmlgraphics/${PN}/source/${P}-src.zip"
LICENSE="Apache-2.0"
SLOT="0"
# doesn't work with java.awt.headless
RESTRICT="test"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="hyphenation jai jimi"

COMMON_DEPEND="
	dev-java/avalon-framework:4.2
	dev-java/batik:1.7
	dev-java/commons-io:1
	dev-java/commons-logging:0
	java-virtuals/servlet-api:2.2
	dev-java/xmlgraphics-commons:1.3
	dev-java/xml-commons-external:1.3
	dev-java/xalan:0
	jai? ( dev-java/sun-jai-bin )
	jimi? ( dev-java/sun-jimi )"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.4
	hyphenation? ( dev-java/offo-hyphenation )
	app-arch/unzip
	${COMMON_DEPEND}"
#	test? (
#		=dev-java/junit-3.8*
#		dev-java/xmlunit
#	)"

java_prepare() {
	# automagic is bad
	java-ant_ignore-system-classes || die

	cd "${S}/lib"
	rm -v *.jar || die

	java-pkg_jarfrom --build-only ant-core ant.jar
	java-pkg_jarfrom avalon-framework-4.2 avalon-framework.jar \
		avalon-framework-4.2.0.jar
	java-pkg_jarfrom batik-1.7
	java-pkg_jarfrom commons-io-1 commons-io.jar commons-io-1.3.1.jar
	java-pkg_jarfrom commons-logging commons-logging.jar \
		commons-logging-1.0.4.jar
	java-pkg_jarfrom --virtual servlet-api-2.2 servlet.jar servlet-2.2.jar
	java-pkg_jarfrom xmlgraphics-commons-1.3
	java-pkg_jarfrom xalan xalan.jar xalan-2.7.0.jar
	java-pkg_jarfrom xml-commons-external-1.3

	use jai && java-pkg_jar-from sun-jai-bin
	use jimi && java-pkg_jar-from sun-jimi
}

EANT_DOC_TARGET="javadocs"
EANT_BUILD_TARGET="package"

src_compile() {
	# because I killed the automagic tests; all our JDK's have JCE
	local af="-Djdk14.present=true -Djce.present=true"
	use hyphenation && af="${af} -Duser.hyph.dir=${EPREFIX}/usr/share/offo-hyphenation/hyph/"
	use jai && af="${af} -Djai.present=true"
	use jimi && af="${af} -Djimi.present=true"

	export ANT_OPTS="-Xmx256m"
	java-pkg-2_src_compile ${af} -Djavahome.jdk14="${JAVA_HOME}"
}

src_test() {
	java-pkg_jar-from --into lib xmlunit-1
	java-pkg_jar-from --into lib junit

	ANT_OPTS="-Xmx1g -Djava.awt.headless=true" eant -Djunit.fork=off junit
}

src_install() {
	java-pkg_dojar build/fop.jar build/fop-sandbox.jar
	if use hyphenation; then
		java-pkg_dojar build/fop-hyph.jar
		insinto /usr/share/${PN}/
		doins -r hyph
	fi

	# doesn't support everything upstream launcher does...
	java-pkg_dolauncher ${PN} --main org.apache.fop.cli.Main

	dodoc NOTICE README

	use doc && java-pkg_dojavadoc build/javadocs
	use examples && java-pkg_doexamples examples/* conf
	use source && java-pkg_dosrc src/java/org src/sandbox/org
}

pkg_postinst(){
	elog "The SVG Renderer and the MIF Handler have not been resurrected"
	elog "They are currently non-functional."
	elog
	elog "The API of FOP has changed considerably and is not backwards-compatible"
	elog "with versions 0.20.5 and 0.91beta. Version 0.92 introduced the new"
	elog "stable API."
}
