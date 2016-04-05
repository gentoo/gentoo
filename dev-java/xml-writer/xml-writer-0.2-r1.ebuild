# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A simple XML Writer"
HOMEPAGE="http://www.megginson.com/downloads/"
SRC_URI="http://www.megginson.com/downloads/${P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src"

java_prepare() {
	java-pkg_clean
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples *.java sample.xml
}
