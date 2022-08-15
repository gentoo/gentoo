# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.5
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for network service discovery using Zeroconf"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
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
		$(cmake_use_find_package zeroconf Avahi)
	)
	use zeroconf || mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_DNSSD=ON )

	ecm_src_configure
}
