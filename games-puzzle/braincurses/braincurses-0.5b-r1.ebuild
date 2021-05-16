# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="An ncurses-based mastermind clone"
HOMEPAGE="https://github.com/bderrly/braincurses"
SRC_URI="mirror://sourceforge/braincurses/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	default

	eapply "${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-as-needed.patch

	# fix buffer overflow (bug #301033)
	sed -i \
		-e 's/guessLabel\[2/guessLabel[3/' \
		curses/windows.cpp \
		|| die 'sed failed'
}

src_install() {
	dobin braincurses
	einstalldocs
}
