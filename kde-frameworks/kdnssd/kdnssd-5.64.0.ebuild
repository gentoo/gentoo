# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Framework for network service discovery using Zeroconf"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="nls zeroconf"

BDEPEND="
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"
DEPEND="
	>=dev-qt/qtnetwork-${QTMIN}:5
	zeroconf? (
		>=dev-qt/qtdbus-${QTMIN}:5
		net-dns/avahi[mdnsresponder-compat]
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_DNSSD=ON
		$(cmake_use_find_package zeroconf Avahi)
	)

	ecm_src_configure
}
