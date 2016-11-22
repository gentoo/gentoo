# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils toolchain-funcs flag-o-matic linux-info

MY_PN="blktrace"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="btrace can show detailed info about what is happening on a block device io queue"
HOMEPAGE="http://git.kernel.dk/cgit/blktrace/"
SRC_URI="http://brick.kernel.dk/snaps/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="doc"

RDEPEND="dev-libs/libaio"
# This is a Linux specific app!
DEPEND="${RDEPEND}
		sys-kernel/linux-headers
		doc? ( virtual/latex-base app-text/dvipdfm )"
S="${WORKDIR}/${MY_P}"

CONFIG_CHECK="~BLK_DEV_IO_TRACE"
WARNING_BLK_DEV_IO_TRACE="you need to enable BLK_DEV_IO_TRACE kernel option if you want to gather traces from this machine"

PATCHES=( "${FILESDIR}"/${PN}-1.1.0-ldflags-parallel-make.patch )

src_compile() {
	append-flags -DLVM_REMAP_WORKAROUND -W -I"${S}"
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
	if use doc; then
		export VARTEXFONTS="${T}/fonts"
		emake docs
	fi
}

src_install() {
	emake install DESTDIR="${D}" prefix="/usr" mandir="/usr/share/man"
	einstalldocs
	use doc && dodoc doc/blktrace.pdf btt/doc/btt.pdf
}
