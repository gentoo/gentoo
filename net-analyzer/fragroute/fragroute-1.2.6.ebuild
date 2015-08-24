# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
MY_P="${P}-ipv6"

inherit autotools-utils

DESCRIPTION="Testing of network intrusion detection systems, firewalls and TCP/IP stacks"
HOMEPAGE="https://code.google.com/p/fragroute-ipv6/"
SRC_URI="https://fragroute-ipv6.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 x86"

RDEPEND="
	dev-libs/libevent
	net-libs/libpcap
	>=dev-libs/libdnet-1.12[ipv6]
"
DEPEND="${RDEPEND}
	virtual/awk"

S="${WORKDIR}/${MY_P}"

DOCS=( INSTALL README TODO )

src_prepare() {
	# Remove broken and old files, autotools will regen needed files
	rm *.m4 acconfig.h missing Makefile.in || die
	# Add missing includes
	sed -i -e "/#define IPUTIL_H/a#include <stdio.h>\n#include <stdint.h>" iputil.h || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--with-libevent="${EPREFIX}"/usr \
		--with-libdnet="${EPREFIX}"/usr \
		--with-libpcap="${EPREFIX}"/usr
	)
	autotools-utils_src_configure
}
