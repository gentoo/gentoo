# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit multilib eutils toolchain-funcs

MY_P=${PN}-${PV/_p/-}
DESCRIPTION="reiser4progs: mkfs, fsck, etc..."
HOMEPAGE="https://www.kernel.org/pub/linux/utils/fs/reiser4/reiser4progs/"
SRC_URI="mirror://kernel/linux/utils/fs/reiser4/reiser4progs/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 -sparc x86"
IUSE="static debug readline"

DEPEND="~sys-libs/libaal-1.0.5
	readline? ( sys-libs/readline )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc-4.4.patch #269240
	epatch "${FILESDIR}"/${P}-readline-6.3.patch #504472
	printf '#!/bin/sh\ntrue\n' > run-ldconfig
}

src_compile() {
	econf \
		$(use_enable static full-static) \
		$(use_enable static mkfs-static) \
		$(use_enable static fsck-static) \
		$(use_enable static debugfs-static) \
		$(use_enable static measurefs-static) \
		$(use_enable static cpfs-static) \
		$(use_enable static resizefs-static) \
		$(use_enable debug) \
		$(use_with readline) \
		--enable-libminimal \
		--sbindir=/sbin \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS CREDITS ChangeLog NEWS README THANKS TODO

	# move shared libs to /
	dodir /$(get_libdir)
	mv "${D}"/usr/$(get_libdir)/lib*.so* "${D}"/$(get_libdir)/ || die
	gen_usr_ldscript libreiser4-minimal.so libreiser4.so librepair.so
}
