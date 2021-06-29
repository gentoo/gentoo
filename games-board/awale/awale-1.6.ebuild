# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Free Awale - The game of all Africa"
HOMEPAGE="https://www.nongnu.org/awale/"
SRC_URI="mirror://nongnu/awale/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui"

RDEPEND="gui? ( dev-lang/tk )"

src_install() {
	if use gui; then
		emake -j1 DESTDIR="${D}" install #799107

		fperms +x /usr/share/${PN}/xawale.tcl

		doicon src/awale.png
		make_desktop_entry xawale "Free Awale"

		rm "${ED}"/usr/share/applications/awale.desktop || die
	else
		dobin src/awale
		doman man/awale.6
	fi

	einstalldocs
}
