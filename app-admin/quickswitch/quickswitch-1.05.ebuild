# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utility to switch network profiles on the fly"
HOMEPAGE="https://muthanna.com/quickswitch/index.html"
SRC_URI="mirror://sourceforge/quickswitch/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ~s390 sparc x86"
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
