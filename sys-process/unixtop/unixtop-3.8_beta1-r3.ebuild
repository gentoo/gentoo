# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools

DESCRIPTION="top for UNIX systems"
HOMEPAGE="http://unixtop.sourceforge.net/"
SRC_URI="mirror://sourceforge/unixtop/top-${PV/_/}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"

S=${WORKDIR}/top-${PV/_/}

src_prepare() {
	epatch "${FILESDIR}"/${P}-ncurses.patch
	epatch "${FILESDIR}"/${P}-no-AX-macros.patch
	epatch "${FILESDIR}"/${P}-renice-segfault.patch
	epatch "${FILESDIR}"/${P}-memleak-fix-v2.patch
	epatch "${FILESDIR}"/${P}-high-threadid-crash.patch
	epatch "${FILESDIR}"/${P}-percent-cpu.patch
	eapply_user
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
