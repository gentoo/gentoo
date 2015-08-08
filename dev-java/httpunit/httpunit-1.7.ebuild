# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc"

inherit java-pkg-2 java-ant-2

DESCRIPTION="HttpUnit emulates the relevant portions of browser behavior"
HOMEPAGE="http://httpunit.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND="
	>=dev-java/junit-3.8:0
	dev-java/rhino:1.6
	dev-java/jtidy:0
	java-virtuals/servlet-api:2.3
	dev-java/xerces:2"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"

java_prepare() {
	find . -name "*.jar" | xargs rm -v

	epatch "${FILESDIR}/rhino-fix-1.6.2.diff"

	cd jars || die
	java-pkg_jar-from junit,rhino-1.6,xerces-2,jtidy,servlet-api-2.3
}

src_compile() {
	java-pkg_filter-compiler jikes

	eant clean jar $(use_doc javadocs)
}

src_install() {
	java-pkg_dojar "lib/${PN}.jar"

	dodoc doc/*.txt

	if use doc; then
		dohtml -r doc/manual doc/tutorial
		java-pkg_dojavadoc doc/api
	fi
}
