# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.10.1
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for network service discovery using Zeroconf"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,network]
	net-dns/avahi[mdnsresponder-compat]
"
RDEPEND="${DEPEND}
	elibc_glibc? ( sys-auth/nss-mdns )
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"
