# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JFreeSVG is a fast, light-weight, vector graphics library for the Java platform"
HOMEPAGE="http://www.jfree.org/jfreesvg/"
SRC_URI="mirror://sourceforge/jfreegraphics2d/${P}.zip"

LICENSE="GPL-3"
SLOT="3.0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.6"

java_prepare() {
	find "${WORKDIR}" -name '*.jar' -print -delete || die
}

src_compile() {
	if ! use debug; then
		antflags="-Dbuild.debug=false -Dbuild.optimize=true"
	fi
	eant -f ant/build.xml compile $(use_doc) $antflags
}

src_install() {
	java-pkg_newjar "./lib/${P}.jar" ${PN}.jar
	dodoc README.md
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/main/java
}
