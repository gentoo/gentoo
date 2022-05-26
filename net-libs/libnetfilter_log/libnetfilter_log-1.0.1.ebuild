# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

DESCRIPTION="Interface to packets that have been logged by the kernel packet filter"
HOMEPAGE="https://www.netfilter.org/projects/libnetfilter_log/"
SRC_URI="https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ~riscv ~sparc x86"

BDEPEND="virtual/pkgconfig"
RDEPEND=">=net-libs/libnfnetlink-1.0.0"
DEPEND="${RDEPEND}"

CONFIG_CHECK="~NETFILTER_NETLINK_LOG"

src_configure() {
	econf --disable-static
}

pkg_setup() {
	linux-info_pkg_setup
	kernel_is lt 2 6 14 && die "requires at least 2.6.14 kernel version"
}
