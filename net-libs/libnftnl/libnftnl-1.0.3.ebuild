# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libnftnl/libnftnl-1.0.3.ebuild,v 1.1 2014/12/18 16:28:17 mrueg Exp $

EAPI=5

inherit base linux-info toolchain-funcs

DESCRIPTION="Netlink API to the in-kernel nf_tables subsystem"
HOMEPAGE="http://netfilter.org/projects/nftables/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="examples json static-libs test xml"
SRC_URI="http://netfilter.org/projects/${PN}/files/${P}.tar.bz2"

RDEPEND=">=net-libs/libmnl-1.0.0
	xml? ( >=dev-libs/mini-xml-2.6 )
	json? ( >=dev-libs/jansson-2.3 )"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

REQUIRED_USE="test? ( json xml )"

pkg_setup() {
	if kernel_is ge 3 13; then
		CONFIG_CHECK="~NF_TABLES"
		linux-info_pkg_setup
	else
		eerror "This package requires kernel version 3.13 or newer to work properly."
	fi
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with xml xml-parsing) \
		$(use_with json json-parsing)
}

src_install() {
	default
	gen_usr_ldscript -a nftnl
	prune_libtool_files

	if use examples; then
		find examples/ -name 'Makefile*' -delete
		dodoc -r examples/
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

src_test() {
	default
	cd tests || die
	./test-script.sh || die
}
