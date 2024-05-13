# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic linux-info

DESCRIPTION="show detailed info about what is happening on a block device io queue"
HOMEPAGE="https://git.kernel.dk/cgit/blktrace/"
SRC_URI="https://brick.kernel.dk/snaps/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ppc x86"
IUSE="doc"

RDEPEND="dev-libs/libaio"
# This is a Linux specific app!
# dev-texlive/texlive-latexextra for placeins.sty
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	doc? (
		virtual/latex-base
		>=app-text/texlive-core-2014
		dev-texlive/texlive-latexextra
	)
"

CONFIG_CHECK="~BLK_DEV_IO_TRACE"
WARNING_BLK_DEV_IO_TRACE="you need to enable BLK_DEV_IO_TRACE kernel option if you want to gather traces from this machine"

src_compile() {
	append-cppflags -DLVM_REMAP_WORKAROUND -W -I"${S}"
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${CPPFLAGS}"
	if use doc; then
		export VARTEXFONTS="${T}/fonts"
		emake docs CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${CPPFLAGS}"
	fi
}

src_install() {
	# Do not remove the CC/FLAGS here; bug 930357
	emake install DESTDIR="${ED}" prefix="/usr" mandir="/usr/share/man" CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${CPPFLAGS}"
	einstalldocs
	use doc && dodoc doc/blktrace.pdf btt/doc/btt.pdf
}
