# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="An 7x7 type midi drum sequencer for Linux"
HOMEPAGE="https://www-ljk.imag.fr/membres/Pierre.Saramito/tk707/"
SRC_URI="mirror://gentoo/${P}.tar.gz
	mirror://gentoo/${P}-updated_tcl2c.patch.gz"
LICENSE="GPL-2+"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=media-libs/alsa-lib-0.9.0
	>=dev-lang/tcl-8.4:0=
	>=dev-lang/tk-8.4:0=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${WORKDIR}/${P}-updated_tcl2c.patch"
	"${FILESDIR}/${P}-asneeded.patch"
	"${FILESDIR}/${P}-nostrip.patch"
	"${FILESDIR}/${P}-glibc-2.27.patch"
)

src_prepare() {
	default
	mv configure.in configure.ac || die
	eautoreconf
}

src_install() {
	HTML_DOCS="tk707.html" default
	rm -rf "${ED}"/usr/share/html/
	make_desktop_entry "${PN}"
}
