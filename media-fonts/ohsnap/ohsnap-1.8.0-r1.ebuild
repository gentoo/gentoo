# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="The ohsnap / osnap monospace font (based on Artwiz Snap)"
HOMEPAGE="https://sourceforge.net/projects/osnapfont"
SRC_URI="mirror://sourceforge/osnapfont/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="otf +pcf"
REQUIRED_USE="|| ( otf pcf )"

BDEPEND="otf? ( x11-apps/fonttosfnt )"
DOCS=( README.ohsnap )

src_compile() {
	if use otf ; then
		for f in *.pcf; do
			fonttosfnt -c -o "${f/pcf/otb}" "$f" || die
		done
	fi
}

src_install() {
	FONT_SUFFIX="$(usev pcf) $(usex otf otb '')"
	einstalldocs
	font_src_install
}
