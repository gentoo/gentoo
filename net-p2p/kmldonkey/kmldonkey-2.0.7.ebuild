# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="Provides integration for the MLDonkey P2P software"
HOMEPAGE="https://www.kde.org/"
SRC_URI="https://api.opensuse.org/public/source/home:eduardhc/${PN}-kde4/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_Plasma=OFF
	)

	kde4-base_src_configure
}

pkg_postinst() {
	if ! has_version net-p2p/mldonkey ; then
		elog ${PN} is a only a client, and requires access to an instance of
		elog net-p2p/mldonkey to function.
	fi
}
