# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="library required by reiser4progs"
HOMEPAGE="http://www.kernel.org/pub/linux/utils/fs/reiser4/libaal/"
SRC_URI="mirror://kernel/linux/utils/fs/reiser4/libaal/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 -sparc x86"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	# remove stupid CFLAG hardcodes
	sed -i \
		-e "/GENERIC_CFLAGS/s:-O3::" \
		-e "/^CFLAGS=/s:\"\":\"${CFLAGS}\":" \
		configure || die "sed"
	cat <<-EOF > run-ldconfig
		#!/bin/sh
		true
	EOF
}

src_compile() {
	econf \
		--enable-libminimal \
		--enable-memory-manager \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS CREDITS ChangeLog NEWS README THANKS TODO

	# move shared libs to /
	dodir /$(get_libdir)
	mv "${D}"/usr/$(get_libdir)/lib*.so* "${D}"/$(get_libdir)/ || die
	gen_usr_ldscript libaal.so libaal-minimal.so
}
