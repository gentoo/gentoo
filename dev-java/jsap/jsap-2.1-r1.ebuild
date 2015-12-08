# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

MY_PN="JSAP"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Java Simple Arguments Parser (JSAP)"
HOMEPAGE="http://sourceforge.net/projects/jsap"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

CDEPEND="
	dev-java/xstream:0
	dev-java/ant-core:0"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	test? (
		dev-java/ant-junit:0
	)"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

S="${WORKDIR}/${MY_P}"

EANT_BUILD_TARGET="jar"
EANT_JAVADOC_TARGET="javadoc"
EANT_ANT_TASKS="rundoc snip"
EANT_BUILD_TEST="test"
EANT_GENTOO_CLASSPATH="
	ant-core
	xstream
"

JAVA_ANT_REWRITE_CLASSPATH="yes"

PATCHES=(
	"${FILESDIR}/${P}-build.xml.patch"
)

java_prepare() {
	java-pkg_clean
	epatch "${PATCHES[@]}"
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "dist/${MY_P}.jar"

	if use doc; then
		dohtml doc/*.html
		java-pkg_dojavadoc doc/javadoc
		dosym /usr/share/doc/${PF}/html/api /usr/share/doc/${PF}/html/javadoc
	fi

	use source && java-pkg_dosrc src/java/com
}
