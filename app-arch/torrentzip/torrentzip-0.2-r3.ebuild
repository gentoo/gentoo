# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils autotools

DESCRIPTION="Create identical zip archives over multiple systems"
HOMEPAGE="https://sourceforge.net/projects/trrntzip"

MY_PN="trrntzip"
MY_P="${MY_PN}_v${PV/.}"

SRC_URI="mirror://sourceforge/trrntzip/${MY_P}_src.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="sys-libs/zlib"
RDEPEND="$DEPEND"

S="${WORKDIR}/${MY_PN}"
DOCS=(README AUTHORS)

src_prepare() {
	export CPPFLAGS+=" -DOF\\(args\\)=args"

	epatch_user

	eautoreconf
}
