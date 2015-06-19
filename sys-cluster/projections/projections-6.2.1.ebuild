# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/projections/projections-6.2.1.ebuild,v 1.1 2013/12/13 20:13:12 nicolasbock Exp $

EAPI=5

inherit java-pkg-2

DESCRIPTION="Projections Performance Analysis Framework for Charm++ Applications"
HOMEPAGE="http://charm.cs.uiuc.edu/"
SRC_URI="http://charm.cs.illinois.edu/distrib/binaries/projections/projections_${PV}.tar.gz"

S="${WORKDIR}/${PN}_${PV}"

LICENSE="charm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	>=virtual/jre-1.6
	sys-cluster/charm[charmtracing]"

src_install() {
	java-pkg_newjar ${PN}.jar
	java-pkg_dolauncher ${PN} \
		--main projections.analysis.ProjMain \
		--jar ${PN}.jar
}
