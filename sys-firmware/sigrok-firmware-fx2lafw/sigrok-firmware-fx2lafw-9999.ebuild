# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-r3 autotools
else
	SRC_URI="binary? ( http://sigrok.org/download/binary/${PN}/${PN}-bin-${PV}.tar.gz )
		!binary? ( http://sigrok.org/download/source/${PN}/${P}.tar.gz )"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="open-source firmware for Cypress FX2 chips which makes them usable as simple logic analyzer hardware"
HOMEPAGE="http://sigrok.org/wiki/Fx2lafw"

LICENSE="GPL-2+"
SLOT="0"
IUSE="binary"

RDEPEND=""
DEPEND="${RDEPEND}
	!binary? ( >=dev-embedded/sdcc-2.9.0[device-lib(+),mcs51(+)] )"

src_unpack() {
	[[ ${PV} == "9999" ]] && git-r3_src_unpack || default
	# The binary & source dirs are slightly diff.
	use binary && S="${WORKDIR}/${PN}-bin-${PV}"
}

src_prepare() {
	[[ ${PV} == "9999" ]] && eautoreconf
}

src_install() {
	if use binary ; then
		insinto /usr/share/sigrok-firmware
		doins *.fw
		dodoc ChangeLog NEWS README
	else
		default
	fi
}
