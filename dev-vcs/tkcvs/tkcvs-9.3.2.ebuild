# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

MYP=${PN}_${PV}
DESCRIPTION="Tcl/Tk-based graphical interface to CVS with Subversion support"
HOMEPAGE="https://tkcvs.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"

DEPEND="dev-lang/tk"
RDEPEND="${DEPEND}
	dev-vcs/cvs
	dev-vcs/subversion
	sys-apps/diffutils
	dev-util/tkdiff"

S="${WORKDIR}"/${MYP}

src_prepare() {
	sed \
		-e "/set MANDIR/s/man man1/share man man1/" \
		-e "/set LIBDIR/s/lib/$(get_libdir)/" \
		-i doinstall.tcl || die
	sed \
		-e "/set TclRoot/s/lib/$(get_libdir)/" \
		-i tkcvs/tkcvs.tcl || die
	default
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
