# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="top for UNIX systems"
HOMEPAGE="http://unixtop.sourceforge.net/"
SRC_URI="mirror://sourceforge/unixtop/top-${PV/_/}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}
	!sys-process/procps"

S=${WORKDIR}/top-${PV/_/}

PATCHES=(
	"${FILESDIR}"/${PN}-3.8_beta1-ncurses.patch
	"${FILESDIR}"/${PN}-3.8_beta1-no-AX-macros.patch
	"${FILESDIR}"/${PN}-3.8_beta1-renice-segfault.patch
	"${FILESDIR}"/${PN}-3.8_beta1-memleak-fix-v2.patch
	"${FILESDIR}"/${PN}-3.8_beta1-high-threadid-crash.patch
	"${FILESDIR}"/${PN}-3.8_beta1-percent-cpu.patch
	"${FILESDIR}"/${PN}-3.8_beta1-winch-segfault.patch
	"${FILESDIR}"/${PN}-3.8_beta1-recent-linux.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=

	# don't do bi-arch cruft on hosts that support that, such as Solaris
	export enable_dualarch=no

	# configure demands an override because on OSX this is "experimental"
	[[ ${CHOST} == *-darwin* ]] && myconf="${myconf} --with-module=macosx"

	econf ${myconf}
}
