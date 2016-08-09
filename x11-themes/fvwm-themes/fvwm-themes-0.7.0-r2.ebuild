# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="A configuration framework for the fvwm window manager"
HOMEPAGE="http://fvwm-themes.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="gnome"

RDEPEND=">=x11-wm/fvwm-2.6.2"
DEPEND="${RDEPEND}
	gnome? ( || (
		media-gfx/imagemagick
		media-gfx/graphicsmagick[imagemagick-compat-compat] ) )"

PATCHES=(
	"${FILESDIR}/${P}-gentoo.patch"
	"${FILESDIR}/${P}-posix-sort.patch"
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf $(use_enable gnome gnome-icons)
}

pkg_postinst() {
	fvwm-themes-config --site --reset
	fvwm-themes-menuapp --site --build-menus --remove-popup

	use gnome && fvwm-themes-images --ft-install --gnome
}
