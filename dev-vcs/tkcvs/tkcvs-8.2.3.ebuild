# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/tkcvs/tkcvs-8.2.3.ebuild,v 1.6 2012/07/03 16:30:31 ranger Exp $

EAPI=4

inherit eutils multilib

DESCRIPTION="Tcl/Tk-based graphical interface to CVS with Subversion support"
HOMEPAGE="http://www.twobarleycorns.net/tkcvs.html"
SRC_URI="http://www.twobarleycorns.net/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-lang/tk"
RDEPEND="${DEPEND}
	dev-vcs/cvs
	dev-vcs/subversion
	sys-apps/diffutils
	dev-util/tkdiff"

src_prepare() {
	sed \
		-e "/set MANDIR/s/man man1/share man man1/" \
		-e "/set LIBDIR/s/lib/$(get_libdir)/" \
		-i doinstall.tcl || die
}

src_install() {
	# bug 66030
	unset DISPLAY
	./doinstall.tcl -nox "${D}"/usr || die

	# dev-tcktk/tkdiff
	rm "${D}"/usr/bin/tkdiff

	# Add docs...this is important
	dodoc {CHANGELOG,FAQ}.txt

	make_desktop_entry ${PN} TkCVS "${EPREFIX}"/usr/$(get_libdir)/tkcvs/bitmaps/ticklefish_med.gif
}
