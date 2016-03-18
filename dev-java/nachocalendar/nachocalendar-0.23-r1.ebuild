# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Flexible Calendar component to the Java Platform"
HOMEPAGE="http://nachocalendar.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.tar.bz2 -> ${P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="test"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	source? ( app-arch/zip )
	>=virtual/jdk-1.6"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src"

java_prepare() {
	java-pkg_clean
	rm -rf src/test || die
}

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres "${PN}.jar" resources
}
