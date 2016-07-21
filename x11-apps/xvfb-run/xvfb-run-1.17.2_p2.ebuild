# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_PN=xorg-server
MY_PV=${PV/_p/-}
DESCRIPTION="Run a command in a virtual X server environment"
HOMEPAGE="https://packages.debian.org/sid/xvfb"
SRC_URI="mirror://debian/pool/main/${MY_PN:0:1}/${MY_PN}/${MY_PN}_${MY_PV}.diff.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/patchutils"
RDEPEND="x11-apps/xauth
	x11-base/xorg-server[xvfb]"

S="${WORKDIR}"/

src_prepare() {
	# Not in src_unpack to silence warning "'patch' call should be moved to src_prepare"
	filterdiff --include='*xvfb-run*' ${MY_PN}_${MY_PV}.diff | patch || die
}

src_install() {
	doman ${PN}.1
	dobin ${PN}
}
