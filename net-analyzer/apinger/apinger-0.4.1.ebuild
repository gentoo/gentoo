# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools

# Switch to ^^ when we switch to EAPI=6.
#MY_PN="${PN^^}"
MY_PN="APINGER"
MY_P="${MY_PN}_${PV//./_}"

DESCRIPTION="Alarm Pinger"
HOMEPAGE="https://github.com/Jajcus/apinger/"
SRC_URI="${HOMEPAGE}archive/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	sys-devel/flex
	virtual/yacc
"

S="${WORKDIR}/${PN}-${MY_P}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	sed -i -e 's|\\$||g' acinclude.m4 || die
	eautoreconf
}

src_compile() {
	emake -C src/ cfgparser1.h
	default
}

src_install() {
	default
	insinto /etc
	doins src/${PN}.conf
}
