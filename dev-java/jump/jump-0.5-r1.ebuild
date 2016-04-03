# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java-based extensible high-precision math library"
HOMEPAGE="http://jump-math.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}-math/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
SLOT="0"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main"

java_prepare() {
	rm -rv src/tests || die
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples src/examples
}
