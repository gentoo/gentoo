# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info

DESCRIPTION="Userspace library for interface to user-space helper for conntrack"
HOMEPAGE="https://www.netfilter.org/projects/libnetfilter_cthelper/"
SRC_URI="https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ppc ~ppc64 x86"

BDEPEND="virtual/pkgconfig"
RDEPEND="net-libs/libmnl:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-clang-export.patch
)

CONFIG_CHECK="~NF_CT_NETLINK_HELPER"

pkg_setup() {
	linux-info_pkg_setup
	kernel_is lt 3 6 0 && ewarn "requires at least 3.6.0 kernel version"
}
