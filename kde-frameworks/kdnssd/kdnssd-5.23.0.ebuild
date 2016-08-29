# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Framework for network service discovery using Zeroconf"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm x86"
IUSE="nls zeroconf"

RDEPEND="
	$(add_qt_dep qtnetwork)
	zeroconf? (
		$(add_qt_dep qtdbus)
		net-dns/avahi[mdnsresponder-compat]
	)
"
DEPEND="${RDEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_DNSSD=ON
		$(cmake-utils_use_find_package zeroconf Avahi)
	)

	kde5_src_configure
}
