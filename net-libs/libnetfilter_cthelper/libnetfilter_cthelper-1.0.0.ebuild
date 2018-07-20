# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit linux-info autotools-utils

DESCRIPTION="userspace library that provides the programming interface to the user-space helper infrastructure"
HOMEPAGE="https://www.netfilter.org/projects/libnetfilter_cthelper/"
SRC_URI="https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa x86"
IUSE="static-libs"

RDEPEND="net-libs/libmnl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~NF_CT_NETLINK_HELPER"

pkg_setup() {
	linux-info_pkg_setup
	kernel_is lt 3 6 0 && ewarn "requires at least 3.6.0 kernel version"
}
