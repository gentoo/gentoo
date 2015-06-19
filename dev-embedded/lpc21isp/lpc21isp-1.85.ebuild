# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/lpc21isp/lpc21isp-1.85.ebuild,v 1.1 2013/04/23 19:53:22 slis Exp $

EAPI=5

inherit versionator

MY_PN="${PN}_$(delete_all_version_separators)"

DESCRIPTION="In-circuit programming (ISP) tool for the NXP microcontrollers"
HOMEPAGE="http://sourceforge.net/projects/lpc21isp/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_install() {
	dobin lpc21isp
}
