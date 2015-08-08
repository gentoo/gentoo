# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="library required by reiser4progs"
HOMEPAGE="https://sourceforge.net/projects/reiser4/"
SRC_URI="mirror://sourceforge/reiser4/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 -sparc x86"
IUSE="static-libs"

DEPEND="virtual/os-headers"

src_prepare() {
	# remove stupid CFLAG hardcodes
	sed -i \
		-e "/GENERIC_CFLAGS/s:-O3::" \
		-e "/^CFLAGS=/s:\"\":\"${CFLAGS}\":" \
		configure || die "sed"
	printf '#!/bin/sh\n:\n' > run-ldconfig
}

src_configure() {
	econf \
		--enable-libminimal \
		--enable-memory-manager \
		$(use_enable static-libs static)
}

src_install() {
	default
	gen_usr_ldscript -a aal{,-minimal}
}
