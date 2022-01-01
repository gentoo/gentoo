# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils linux-info ltprune multilib

DESCRIPTION="library providing interface to extended accounting infrastructure"
HOMEPAGE="https://netfilter.org/projects/libnetfilter_acct/"
SRC_URI="https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 x86 ~amd64-linux"
IUSE="examples"

RDEPEND="
	net-libs/libmnl
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( README )
CONFIG_CHECK="~NETFILTER_NETLINK_ACCT"

pkg_setup() {
	kernel_is lt 3 3 && ewarn "This package will work with kernel version 3.3 or higher"
	linux-info_pkg_setup
}

src_configure() {
	econf \
		--libdir="${EPREFIX}"/$(get_libdir)
}

src_install() {
	default

	dodir /usr/$(get_libdir)/pkgconfig/
	mv "${ED}"/{,usr/}$(get_libdir)/pkgconfig/${PN}.pc || die

	if use examples; then
		find examples/ -name "Makefile*" -exec rm -f '{}' + || die 'find failed'
		dodoc -r examples/
		docompress -x /usr/share/doc/${P}/examples
	fi

	prune_libtool_files
}
