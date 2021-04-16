# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit epatch toolchain-funcs flag-o-matic linux-info

DESCRIPTION="btrace can show detailed info about what is happening on a block device io queue"
HOMEPAGE="https://git.kernel.dk/cgit/blktrace/"
MY_PN="blktrace"
MY_P="${MY_PN}-${PV}"
SRC_URI="https://brick.kernel.dk/snaps/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"
RDEPEND=""
# This is a Linux specific app!
DEPEND="${RDEPEND}
		sys-kernel/linux-headers
		doc? (
			virtual/latex-base
			>=app-text/texlive-core-2014
		)
		dev-libs/libaio"
S="${WORKDIR}/${MY_P}"

CONFIG_CHECK="~BLK_DEV_IO_TRACE"
WARNING_BLK_DEV_IO_TRACE="you need to enable BLK_DEV_IO_TRACE kernel option if you want to gather traces from this machine"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.1.0-ldflags-parallel-make.patch
}

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
	dodoc README
	use doc && dodoc doc/blktrace.pdf btt/doc/btt.pdf
}
