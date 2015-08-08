# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit gnustep-2

MY_PN=SimpleAgenda
DESCRIPTION="a simple calendar and agenda application"
HOMEPAGE="http://coyote.octets.fr/simpleagenda"
SRC_URI="http://coyote.octets.fr/pub/gnustep/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="dbus"

DEPEND=">=dev-libs/libical-0.27
	>=virtual/gnustep-back-0.20.0
	dbus? ( gnustep-libs/dbuskit )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${PV}

src_configure() {
	egnustep_env
	econf $(use_enable dbus dbuskit)
}
