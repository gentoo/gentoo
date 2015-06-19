# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/xstow/xstow-1.0.1.ebuild,v 1.7 2015/04/19 09:37:52 pacho Exp $

EAPI=5

inherit autotools eutils

DESCRIPTION="replacement for GNU stow with extensions"
HOMEPAGE="http://xstow.sourceforge.net/"
SRC_URI="mirror://sourceforge/xstow/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="ncurses"

DEPEND="ncurses? ( sys-libs/ncurses )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ncurses.patch
	eautoreconf
}

src_configure() {
	econf $(use_with ncurses curses)
}

src_install() {
	emake DESTDIR="${D}" docdir="/usr/share/doc/${PF}/html" install
	dodoc AUTHORS ChangeLog NEWS README TODO

	# create new STOWDIR
	dodir /var/lib/xstow

	# install env.d file to add STOWDIR to PATH and LDPATH
	doenvd "${FILESDIR}/99xstow" || die "doenvd failed"
}

pkg_postinst() {
	elog "We now recommend that you use /var/lib/xstow as your STOWDIR"
	elog "instead of /usr/local in order to avoid conflicts with the"
	elog "symlink from /usr/lib64 -> /usr/lib.  See Bug 246264"
	elog "(regarding app-admin/stow, equally applicable to XStow) for"
	elog "more details on this change."
	elog "For your convenience, PATH has been updated to include"
	elog "/var/lib/bin."
}
