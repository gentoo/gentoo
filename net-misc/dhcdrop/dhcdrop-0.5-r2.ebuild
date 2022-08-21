# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Effectively suppresses illegal DHCP servers on the LAN"
HOMEPAGE="http://www.netpatch.ru/devel/dhcdrop/"
SRC_URI="http://www.netpatch.ru/projects/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE="static"

RDEPEND="!static? ( net-libs/libpcap )"
DEPEND="${RDEPEND}
	static? ( net-libs/libpcap[static-libs] )"

DOCS=( AUTHORS ChangeLog INSTALL NEWS README )

src_prepare() {
	default

	# Fix building with clang, bug #731694
	sed -i '/^PACKAGE_/s/"//g' configure \
		|| die "sed failed for configure"
	# wrt #861608
	sed -i  -e 's/inline void rand_ether_addr/static void rand_ether_addr/' \
		-e 's/inline void print_ether/static void print_ether/' \
		src/dhcdrop.{c,h} || die "sed failed ofr dhcdrop.c,h"
}

src_configure() {
	econf "$(use static && echo '--enable-static-build')"
}
