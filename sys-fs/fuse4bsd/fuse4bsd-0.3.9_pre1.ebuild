# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit portability toolchain-funcs eutils flag-o-matic

DESCRIPTION="Fuse for FreeBSD"
HOMEPAGE="http://fuse4bsd.creo.hu/"
# -sbin is needed for getmntopts.c, hardcoding 6.2 is nasty but can't think of
# any better solution right now
SRC_URI="http://ftp.FreeBSD.org/pub/FreeBSD/ports/distfiles/fuse4bsd/498acaef33b0.tar.gz
	mirror://gentoo/freebsd-sbin-9.1.tar.bz2"
S="${WORKDIR}/fuse4bsd-498acaef33b0"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86-fbsd"
IUSE="doc"

DEPEND=">=sys-freebsd/freebsd-sources-9.1
	virtual/pmake
	doc? ( app-text/deplate )"
RDEPEND="sys-fs/fuse"

QA_TEXTRELS="boot/modules/fuse.ko"

src_prepare() {
	cp /usr/include/fuse/fuse_kernel.h fuse_module/ || die
	cp "${WORKDIR}/sbin/mount/getmntopts.c" mount_fusefs/ || die
	epatch "${FILESDIR}"/${P}-ports.patch
	epatch "${FILESDIR}"/${P}-fbsd91.patch
	sed -i -e "s:^DEPLATE=.*:DEPLATE=${EPREFIX}/usr/bin/deplate:" \
		doc/Makefile || die
}

src_compile() {
	filter-ldflags "-Wl,--hash-style=*"
	tc-export CC
	cd "${S}"/fuse_module
	$(get_bmake) \
		KMODDIR=/boot/modules BINDIR=/usr/sbin MANDIR=/usr/share/man/man \
		MOUNT="${WORKDIR}/sbin/mount" LDFLAGS="$(raw-ldflags)" \
		|| die "$(get_bmake) failed"

	cd "${S}"/mount_fusefs
	$(get_bmake) \
		KMODDIR=/boot/modules BINDIR=/usr/sbin MANDIR=/usr/share/man/man \
		MOUNT="${WORKDIR}/sbin/mount" \
		|| die "$(get_bmake) failed"

	if use doc; then
		cd "${S}"/doc
		$(get_bmake) all || die "$(get_bmake) failed"
	fi
}

src_install() {
	dodir /boot/modules
	$(get_bmake) \
		KMODDIR=/boot/modules BINDIR=/usr/sbin MANDIR=/usr/share/man/man \
		DESTDIR="${ED}" install \
		|| die "$(get_bmake) failed"

	dodoc doc/{CREDITS,README}
	if use doc; then
		dodoc doc/plaintext_out/* doc/pdf_out/*.pdf
		docinto html
		dodoc doc/html_chunked_out/*
	fi
}
