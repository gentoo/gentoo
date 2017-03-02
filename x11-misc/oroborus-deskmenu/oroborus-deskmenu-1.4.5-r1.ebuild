# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=${PN/oroborus-//}

DESCRIPTION="root menu program for Oroborus"
HOMEPAGE="http://www.oroborus.org"
SRC_URI="mirror://debian/pool/main/d/${MY_PN}/${MY_PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=x11-libs/gtk+-2*
	!x11-wm/oroborus-extras"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PN}-${PV}

DOCS=( AUTHORS ChangeLog NEWS README TODO example_rc )
