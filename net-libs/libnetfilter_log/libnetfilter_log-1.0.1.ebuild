# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit linux-info autotools-utils

DESCRIPTION="interface to packets that have been logged by the kernel packet filter"
HOMEPAGE="http://www.netfilter.org/projects/libnetfilter_log/"
SRC_URI="http://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ~sparc x86"
IUSE="static-libs"

RDEPEND=">=net-libs/libnfnetlink-1.0.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~NETFILTER_NETLINK_LOG"

pkg_setup() {
	linux-info_pkg_setup
	kernel_is lt 2 6 14 && die "requires at least 2.6.14 kernel version"
}
