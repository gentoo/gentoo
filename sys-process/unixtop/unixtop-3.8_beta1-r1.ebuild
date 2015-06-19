# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/unixtop/unixtop-3.8_beta1-r1.ebuild,v 1.2 2010/01/15 19:55:39 ulm Exp $

inherit eutils autotools

DESCRIPTION="top for UNIX systems"
HOMEPAGE="http://unixtop.sourceforge.net/"
SRC_URI="mirror://sourceforge/unixtop/top-${PV/_/}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"

S=${WORKDIR}/top-${PV/_/}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-ncurses.patch
	epatch "${FILESDIR}"/${P}-no-AX-macros.patch
	epatch "${FILESDIR}"/${P}-renice-segfault.patch
	epatch "${FILESDIR}"/${P}-memleak-fix.patch
	eautoreconf
}

src_compile() {
	local myconf=

	# don't do bi-arch cruft on hosts that support that, such as Solaris
	export enable_dualarch=no

	# configure demands an override because on OSX this is "experimental"
	[[ ${CHOST} == *-darwin* ]] && myconf="${myconf} --with-module=macosx"

	econf ${myconf} || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README FAQ Y2K
}
