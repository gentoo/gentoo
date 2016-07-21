# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

_UNDEL_DEB=2.1
_UNDEL_E2FS=1.42.6

DESCRIPTION="A utility to undelete files from an ext3 or ext4 partition"
HOMEPAGE="http://extundelete.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-${_UNDEL_DEB}.debian.tar.gz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sys-fs/e2fsprogs-${_UNDEL_E2FS}
	>=sys-libs/e2fsprogs-libs-${_UNDEL_E2FS}"
DEPEND=${RDEPEND}

DOCS=README

src_prepare() {
	local d=${WORKDIR}/debian/patches
	EPATCH_SOURCE=${d} epatch $(<"${d}"/series)
}
