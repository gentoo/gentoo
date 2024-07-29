# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="A GTK program for drawing organic molecules"
HOMEPAGE="http://ruby.chemie.uni-freiburg.de/~martin/chemtool/"
SRC_URI="http://ruby.chemie.uni-freiburg.de/~martin/chemtool/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="emf gnome nls"

RDEPEND="
	dev-libs/glib:2
	media-gfx/transfig
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/pango
	emf? ( media-libs/libemf )"
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
		$(use_with gnome gnomedir "${EPREFIX}"/usr) \
		$(use_enable emf)
}

src_install() {
	default

	insinto /usr/share/chemtool/examples
	doins -r examples/.

	insinto /usr/share/pixmaps
	doins chemtool.xpm

	if ! use nls; then
		rm -rf "${ED}"/usr/share/locale || die
	fi

	make_desktop_entry chemtool Chemtool chemtool "Education;Science;Chemistry"
}
