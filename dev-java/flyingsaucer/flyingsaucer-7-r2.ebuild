# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="100% Java XHTML+CSS renderer"
HOMEPAGE="https://xhtmlrenderer.dev.java.net/"
SRC_URI="http://www.pdoubleya.com/projects/${PN}/downloads/r${PV}/${PN}-R${PV}final-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="minimal svg ${JAVA_PKG_IUSE}"

COMMON_DEP="
	>=dev-java/itext-2.0.8:0
	svg? ( dev-java/svgsalamander:0 )"

# 1.5 because svgsalamander is 1.5
RDEPEND="
	svg? ( >=virtual/jre-1.5 )
	!svg? ( >=virtual/jre-1.4 )
	${COMMON_DEP}"

DEPEND="
	svg? ( >=virtual/jdk-1.5 )
	!svg? ( >=virtual/jdk-1.4 )
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}"

java_prepare() {
	epatch "${FILESDIR}"/7-itext-2.0.8.patch

	# Save lib/minium.jar because it's not publicly available although it's in
	# public domain, will separate if something else needs it
	rm -v lib/itext*.jar lib/dev/*.jar lib/dev/*/*.jar || die

	cd lib || die
	java-pkg_jar-from itext

	if use svg; then
		java-pkg_jar-from svgsalamander
		EANT_BUILD_TARGET+=" jar.svg"
	fi

	use minimal || EANT_BUILD_TARGET=" jar.docbook jar.about jar.browser"
}

# Investigate building demos/photogallery demos/filebrowser because
# the files seem to be missing for jar.photogaller jar.filebrowser
EANT_BUILD_TARGET="jar.core"
EANT_DOC_TARGET="docs"

RESTRICT="test"

# Needs X11.
src_test() {
	eant test -Djava.awt.headless=true
}

src_install() {
	java-pkg_dojar build/*.jar lib/minium.jar

	dodoc README || die

	use doc && java-pkg_dojavadoc doc/user/api
	use source && java-pkg_dosrc src/java/org
}
