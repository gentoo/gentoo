# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/osmosis/osmosis-0.35.1.ebuild,v 1.1 2011/06/01 13:08:38 scarabeus Exp $

EAPI=4

WANT_ANT_TASKS="ant-nodeps"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Commandline tool to process openstreetmap data"
HOMEPAGE="http://wiki.openstreetmap.org/index.php/Osmosis"
SRC_URI="http://bretth.dev.openstreetmap.org/osmosis-build/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql postgres"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

src_compile() {
	eant build_binary || die
}

src_install() {
	java-pkg_newjar "${PN}.jar" || die "java-pkg_newjar failed"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar" || die "java-pkg_dolauncher failed"

	dodoc readme.txt changes.txt doc/*.txt || die "dodoc failed"
}
