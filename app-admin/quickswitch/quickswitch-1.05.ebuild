# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Utility to switch network profiles on the fly"
SRC_URI="mirror://sourceforge/quickswitch/${P}.tar.gz"
HOMEPAGE="http://quickswitch.sf.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc s390 amd64"
IUSE="ncurses"

DEPEND=">=dev-lang/perl-5.6.0"
RDEPEND="ncurses? ( dev-perl/CursesWidgets )"

PATCHES=( "${FILESDIR}"/${PN}-1.05-fix-paths.patch )

src_install() {
	dobin switchto
	use ncurses && dobin switcher

	insinto /etc/quickswitch
	newins switchto.conf switchto.conf.sample

	einstalldocs
}
