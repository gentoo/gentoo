# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Algol 68 Genie compiler-interpreter"
HOMEPAGE="https://jmvdveer.home.xs4all.nl/en.algol-68-genie.html"
SRC_URI="https://jmvdveer.home.xs4all.nl/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+curl +gsl +mpfr +ncurses plotutils postgres +readline"

RDEPEND="
	curl? ( net-misc/curl )
	gsl? ( sci-libs/gsl:= )
	mpfr? ( dev-libs/mpfr:= )
	plotutils? ( media-libs/plotutils )
	postgres? ( dev-db/postgresql:* )
	readline? ( sys-libs/readline:= )
"
DEPEND="
	${RDEPEND}
"

PATCHES=( "${FILESDIR}/${PN}-3.3.21-configure-implicit.patch" )

src_configure() {
	local -a myconf=(
		$(use_enable curl)
		$(use_enable gsl)
		$(use_enable mpfr)
		$(use_enable ncurses curses)
		$(use_enable plotutils)
		$(use_enable postgres postgresql)
		$(use_enable readline)
		$(use_with ncurses)
	)
	econf "${myconf[@]}"
}
