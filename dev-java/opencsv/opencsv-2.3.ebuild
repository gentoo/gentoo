# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A very simple csv (comma-separated values) parser library for Java"
HOMEPAGE="http://opencsv.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src-with-libs.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

S="${WORKDIR}/${P}"

DEPEND="app-arch/unzip
	>=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

RESTRICT="test"

java_prepare() {
	rm lib/* || die
}

src_install() {
	java-pkg_newjar deploy/${P}.jar ${PN}.jar
	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc src/au
}
