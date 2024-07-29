# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools desktop

DESCRIPTION="A GTK program for drawing organic molecules"
HOMEPAGE="http://ruby.chemie.uni-freiburg.de/~martin/chemtool/"
SRC_URI="http://ruby.chemie.uni-freiburg.de/~martin/chemtool/${P}.tar.gz
	https://upload.wikimedia.org/wikipedia/commons/5/58/Adamantane_acsv.svg -> chemtool.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="emf"

RDEPEND="
	dev-libs/glib:2
	>=media-gfx/fig2dev-3.2.9-r1
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/pango
	emf? ( media-libs/libemf )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-no-underlinking.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-fix-tests.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-undo \
		--enable-menu \
		--without-kdedir \
		$(use_enable emf)
}

src_install() {
	default

	insinto /usr/share/chemtool/examples
	doins -r examples/.

	doicon "${DISTDIR}"/chemtool.png
	make_desktop_entry chemtool Chemtool chemtool "Education;Science;Chemistry"
}
