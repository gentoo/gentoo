# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="JSAP"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Java Simple Arguments Parser (JSAP)"
HOMEPAGE="http://sourceforge.net/projects/jsap"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

CDEPEND="
	dev-java/xstream:0
	dev-java/ant-core:0"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

S="${WORKDIR}/${MY_P}"

JAVA_GENTOO_CLASSPATH="
	xstream
	ant-core
"

java_prepare() {
	java-pkg_clean
	find . -type f -name "Test*.java" -delete || die
}
