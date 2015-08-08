# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

JAXEN_V="1.1.6"
JAXEN_P="jaxen-${JAXEN_V}"

DESCRIPTION="A new XML object model"
HOMEPAGE="http://cafeconleche.org/XOM/index.html"
# Bundled jaxen as its moved under XOM's namespace
SRC_URI="http://cafeconleche.org/XOM/${P}.tar.gz
	http://dist.codehaus.org/jaxen/distributions/${JAXEN_P}-src.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

COMMON_DEPEND="dev-java/xerces:2
		dev-java/xml-commons-external:1.3
		examples? ( java-virtuals/servlet-api:2.4 )"

RDEPEND=">=virtual/jre-1.4
		${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.4
		dev-java/jarjar:1
		${COMMON_DEPEND}"

S="${WORKDIR}/XOM"

# Test require network access to pass.
# They need a redirected http document on public web.
RESTRICT="test"

java_prepare() {
	epatch "${FILESDIR}/${PN}-1.2.6.patch"
	epatch "${FILESDIR}/${PN}-strip-fallback-parser.patch" #399119

	# Delete test files as they aren't installed
	rm -vr src/nu/xom/tests || die

	# Delete bundled jars
	rm -v *.jar lib/*.jar || die

	# Delete bundled classes
	find . -name "*.class" -delete -print || die

	# Move bundled jaxen to where the build.xml expects it
	mv "${WORKDIR}"/${JAXEN_P}/ lib/ || die

	java-pkg_jar-from --into lib/ xml-commons-external-1.3
	java-pkg_jar-from --into lib/ xerces-2
	java-pkg_jar-from --build-only --into lib/ jarjar-1

	# Tagsoup is only needed to run betterdoc but we use the pregenerated ones.
}

src_compile() {
	local ant_flags="-Ddebug=off"
	use examples && ant_flags="${ant_flags} -Dservlet.jar=$(java-pkg_getjar servlet-api-2.4 servlet-api.jar)"

	ANT_TASKS="jarjar-1" eant jar ${ant_flags}\
		$(use examples && echo samples)
}

src_install() {
	java-pkg_newjar build/${P}.jar ${PN}.jar
	use examples && java-pkg_dojar build/xom-samples.jar
	dodoc Todo.txt

	use doc && java-pkg_dojavadoc apidocs/
	use source && java-pkg_dosrc src/*
	use examples && java-pkg_doexamples --subdir nu/xom/samples src/nu/xom/samples
}
