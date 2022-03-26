# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info verify-sig

DESCRIPTION="netlink interface for conntrack timeout infrastructure in kernel's packet filter"
HOMEPAGE="https://www.netfilter.org/projects/libnetfilter_cttimeout/"
SRC_URI="https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2
	verify-sig? ( https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2.sig )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ppc ppc64 ~riscv x86"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/netfilter.org.asc

BDEPEND="virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-netfilter )"
RDEPEND="net-libs/libmnl:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-clang-export.patch
)

CONFIG_CHECK="~NF_CT_NETLINK_TIMEOUT"

pkg_setup() {
	linux-info_pkg_setup
	kernel_is lt 3 4 0 && ewarn "requires at least 3.4.0 kernel version"
}
