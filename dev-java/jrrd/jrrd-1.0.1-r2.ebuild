# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit autotools java-pkg-2

DESCRIPTION="Java Interface to Tobias Oetiker's RRDtool"

SRC_URI="mirror://sourceforge/opennms/${P}.tar.gz"
HOMEPAGE="http://www.opennms.org/"
KEYWORDS="amd64 x86"
LICENSE="GPL-2"

SLOT="0"

CDEPEND="net-analyzer/rrdtool"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

PATCHES=( "${FILESDIR}/${P}-javacflags.patch" )

src_configure() {
	econf
}

src_compile(){
	emake -j1
	use doc && ejavadoc -d javadoc $(find org -name "*.java")
}

src_install() {
	java-pkg_newjar "${S}/${PN}.jar"
	java-pkg_doso .libs/*.so
	use source && java-pkg_dosrc org
	use doc && java-pkg_dojavadoc javadoc
}
