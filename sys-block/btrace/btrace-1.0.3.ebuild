# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils toolchain-funcs flag-o-matic linux-info

DESCRIPTION="btrace can show detailed info about what is happening on a block device io queue"
HOMEPAGE="https://www.kernel.org/pub/linux/kernel/people/axboe/blktrace/"
MY_PN="blktrace"
MY_P="${MY_PN}-${PV}"
SRC_URI="http://brick.kernel.dk/snaps/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"
RDEPEND=""
# This is a Linux specific app!
DEPEND="${RDEPEND}
		sys-kernel/linux-headers
		doc? ( virtual/latex-base app-text/dvipdfm )
		dev-libs/libaio"
S="${WORKDIR}/${MY_P}"

CONFIG_CHECK="~BLK_DEV_IO_TRACE"
WARNING_BLK_DEV_IO_TRACE="you need to enable BLK_DEV_IO_TRACE kernel option if you want to gather traces from this machine"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.1-ldflags-parallel-make.patch
}

src_compile() {
	append-flags -DLVM_REMAP_WORKAROUND -W -I"${S}"
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
	if use doc; then
		export VARTEXFONTS="${T}/fonts"
		emake docs || die "emake docs failed"
	fi
}

src_install() {
	emake install DESTDIR="${D}" prefix="/usr" mandir="/usr/share/man" || die "emake install failed"
	dodoc README
	use doc && dodoc doc/blktrace.pdf btt/doc/btt.pdf
}
