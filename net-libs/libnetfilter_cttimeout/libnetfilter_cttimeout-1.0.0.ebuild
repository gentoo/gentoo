# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit linux-info autotools-utils

DESCRIPTION="netlink interface to the connection tracking timeout infrastructure in the kernel packet filter"
HOMEPAGE="http://www.netfilter.org/projects/libnetfilter_cttimeout"
SRC_URI="http://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa x86"
IUSE="static-libs"

RDEPEND="net-libs/libmnl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~NF_CT_NETLINK_TIMEOUT"

pkg_setup() {
	linux-info_pkg_setup
	kernel_is lt 3 4 0 && ewarn "requires at least 3.4.0 kernel version"
}
