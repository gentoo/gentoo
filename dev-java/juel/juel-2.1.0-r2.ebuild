# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Implementation of the Unified Expression Language (EL) - JSR-245"
HOMEPAGE="http://juel.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/unzip )"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/api src/impl"

java_prepare() {
	java-pkg_clean
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples src/samples/*
}
