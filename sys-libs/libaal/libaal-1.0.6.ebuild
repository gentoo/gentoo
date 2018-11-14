# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit toolchain-funcs eutils

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
	epatch "${FILESDIR}"/${PN}-1.0.6-glibc26.patch
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
