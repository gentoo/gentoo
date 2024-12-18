# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utility for examining and tuning ethernet-based network interfaces"
HOMEPAGE="https://www.kernel.org/pub/software/network/ethtool/"
SRC_URI="https://www.kernel.org/pub/software/network/ethtool/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv sparc x86"
IUSE="+netlink"

RDEPEND="netlink? ( net-libs/libmnl )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	netlink? ( virtual/pkgconfig )
"

src_configure() {
	econf $(use_enable netlink)
}
