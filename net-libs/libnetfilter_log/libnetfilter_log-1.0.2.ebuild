# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info

DESCRIPTION="Interface to packets that have been logged by the kernel packet filter"
HOMEPAGE="https://www.netfilter.org/projects/libnetfilter_log/"
SRC_URI="https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~riscv ~sparc ~x86"
IUSE="doc"

RDEPEND=">=net-libs/libnfnetlink-1.0.0
	>=net-libs/libmnl-1.0.3"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? ( app-doc/doxygen )"

CONFIG_CHECK="~NETFILTER_NETLINK_LOG"

pkg_setup() {
	linux-info_pkg_setup
	kernel_is lt 2 6 14 && die "requires at least 2.6.14 kernel version"
}

src_configure() {
	econf \
		$(use_enable doc html-doc) \
		$(use_enable doc man-pages)
}
