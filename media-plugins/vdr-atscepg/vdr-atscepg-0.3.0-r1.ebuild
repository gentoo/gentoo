# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: receive schedule and event information from ATSC broadcasts"
HOMEPAGE="http://www.fepg.org/atscepg.html"
SRC_URI="http://www.fepg.org/files/${P}.tgz
		mirror://gentoo/atscepg-${PV}_vdr-1.7.13.tbz
		http://dev.gentoo.org/~hd_brummy/distfiles/atscepg-${PV}_vdr-1.7.13.tbz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-2"

RDEPEND="${DEPEND}"

src_configure() {
	# disabled gcc -std=c++11,
	# plugin is dead on upstream since 2010, there is no fixing available
	filter-flags -std=c++11
}

src_prepare() {
	vdr-plugin-2_src_prepare

	epatch "${WORKDIR}/atscepg-${PV}_vdr-1.7.13.diff"

	fix_vdr_libsi_include tables.cpp filter.cpp scanner.cpp
}
