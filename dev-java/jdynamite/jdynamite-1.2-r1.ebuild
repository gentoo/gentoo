# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PV="${PV/./_}"
DESCRIPTION="Dynamic Template in Java"
HOMEPAGE="http://jdynamite.sourceforge.net/doc/jdynamite.html"
SRC_URI="mirror://sourceforge/${PN}/${PN}${MY_PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

CDEPEND="dev-java/gnu-regexp:1"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

S="${WORKDIR}/${PN}${PV}"

JAVA_GENTOO_CLASSPATH="gnu-regexp-1"
JAVA_SRC_DIR="src/cb/jdynamite"

java_prepare() {
	rm -fvr "${S}"/{lib/*,cb,src/gnu,build.xml} || die
}
