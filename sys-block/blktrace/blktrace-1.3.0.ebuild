# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs flag-o-matic linux-info

MY_PN="blktrace"
if [[ ${PV} =~ _p20 ]]; then
	#https://brick.kernel.dk/snaps/blktrace-git-20210419122502.tar.gz
	MY_P="${MY_PN}-git-${PV/*_p}"
	EXT='tar.gz'
	S="${WORKDIR}/${PN}"
else
	MY_P="${MY_PN}-${PV}"
	EXT='tar.bz2'
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="show detailed info about what is happening on a block device io queue"
HOMEPAGE="https://git.kernel.dk/cgit/blktrace/"
SRC_URI="https://brick.kernel.dk/snaps/${MY_P}.${EXT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE="doc"

RDEPEND="dev-libs/libaio"
# This is a Linux specific app!
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	doc? (
		virtual/latex-base
		>=app-text/texlive-core-2014
	)
"

CONFIG_CHECK="~BLK_DEV_IO_TRACE"
WARNING_BLK_DEV_IO_TRACE="you need to enable BLK_DEV_IO_TRACE kernel option if you want to gather traces from this machine"

PATCHES=(
	#"${FILESDIR}"/${P}-overlapping-io-stats.patch
	#"${FILESDIR}"/${PN}-1.2.0-ldflags.patch #335741
	#"${FILESDIR}"/${PN}-1.2.0-parallel-build.patch #335741
)

src_compile() {
	append-cppflags -DLVM_REMAP_WORKAROUND -W -I"${S}"
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${CPPFLAGS}"
	if use doc; then
		export VARTEXFONTS="${T}/fonts"
		emake docs
	fi
}

src_install() {
	emake install CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${CPPFLAGS}" DESTDIR="${ED}" prefix="/usr" mandir="/usr/share/man"
	einstalldocs
	use doc && dodoc doc/blktrace.pdf btt/doc/btt.pdf
}
