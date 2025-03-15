# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for network service discovery using Zeroconf"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="zeroconf"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[network]
	zeroconf? (
		>=dev-qt/qtbase-${QTMIN}:6[dbus]
		net-dns/avahi[mdnsresponder-compat]
	)
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package zeroconf Avahi)
	)
	use zeroconf || mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_DNSSD=ON )

	ecm_src_configure
}
