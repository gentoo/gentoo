# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="'Dive Into Python' by Mark Pilgrim - Python 3.x book"
HOMEPAGE="http://www.diveintopython3.net/"
SRC_URI="http://dev.gentoo.org/~monsieurp/packages/${P}.zip"
LICENSE="CC-BY-SA-3.0"
SLOT="3"

KEYWORDS="~amd64 ~ppc64 ~ppc ~x86"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${PV}-master"

src_prepare() {
	default
}

src_install() {
	insinto /usr/share/doc/${PN}-${SLOT}
	doins -r *
}
