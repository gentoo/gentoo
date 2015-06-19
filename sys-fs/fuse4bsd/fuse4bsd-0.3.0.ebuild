# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/fuse4bsd/fuse4bsd-0.3.0.ebuild,v 1.6 2013/08/14 09:16:12 patrick Exp $

inherit portability toolchain-funcs eutils flag-o-matic

DESCRIPTION="Fuse for FreeBSD"
HOMEPAGE="http://fuse4bsd.creo.hu/"
# -sbin is needed for getmntopts.c, hardcoding 6.2 is nasty but can't think of
# any better solution right now
SRC_URI="http://fuse4bsd.creo.hu/downloads/${P}.tar.gz
	mirror://gentoo/freebsd-sbin-6.2.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86-fbsd"
IUSE=""

DEPEND=">=sys-freebsd/freebsd-sources-6.2
	virtual/pmake"
RDEPEND="sys-fs/fuse"

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp /usr/include/fuse/fuse_kernel.h fuse_module/
	cp "${WORKDIR}/sbin/mount/getmntopts.c" mount_fusefs/
	epatch "${FILESDIR}"/${P}-gcc4.patch
	epatch "${FILESDIR}"/${P}-ports.patch
}

src_compile() {
	tc-export CC
	$(get_bmake) \
		KMODDIR=/boot/modules BINDIR=/usr/sbin MANDIR=/usr/share/man/man \
		MOUNT="${WORKDIR}/sbin/mount" LDFLAGS="$(raw-ldflags)" \
		|| die "$(get_bmake) failed"
}

src_install() {
	dodir /boot/modules
	$(get_bmake) \
		KMODDIR=/boot/modules BINDIR=/usr/sbin MANDIR=/usr/share/man/man \
		DESTDIR="${D}" install \
		|| die "$(get_bmake) failed"

	for docdir in ./ ./plaintext_out ./html_chunked_out ./html_aux; do
		docinto ${docdir}
		dodoc doc/${docdir}/*
	done
}
