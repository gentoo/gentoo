# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils

DESCRIPTION="./configure like generator for qmake-based projects"
HOMEPAGE="http://delta.affinix.com/qconf/"
SRC_URI="http://delta.affinix.com/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm hppa ~ppc ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="+qt4 qt5"

RDEPEND="
	qt4? ( dev-qt/qtcore:4 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtxml:5
	)
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README.md TODO )

REQUIRED_USE="^^ ( qt4 qt5 )"

src_configure() {
	# Fake ./configure. Fails on unknown options
	./configure \
		--prefix="${EPREFIX}/usr" \
		$(use qt4 && echo "--qtdir=$(qt4_get_libdir)") \
		$(use qt5 && echo "--qtdir=$(qt5_get_libdir)/qt5") \
		--extraconf=QMAKE_STRIP= \
		--verbose || die

	[ ! -f Makefile ] && die "Makefile generation failure"

	use qt4 && eqmake4
	use qt5 && eqmake5
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
	einstalldocs
	insinto /usr/share/doc/${PF}
	doins -r examples
}
