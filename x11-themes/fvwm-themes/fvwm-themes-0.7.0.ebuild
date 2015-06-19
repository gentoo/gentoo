# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/fvwm-themes/fvwm-themes-0.7.0.ebuild,v 1.18 2011/11/11 17:13:22 ssuominen Exp $

EAPI=2
inherit autotools eutils

DESCRIPTION="A configuration framework for the fvwm window manager"
HOMEPAGE="http://fvwm-themes.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="gnome"

RDEPEND=">=x11-wm/fvwm-2.6.2"
DEPEND="${RDEPEND}
	gnome? ( || (
		media-gfx/imagemagick
		media-gfx/graphicsmagick[imagemagick] )	)"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-posix-sort.patch

	eautoreconf
}

src_configure() {
	econf $(use_enable gnome gnome-icons)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	fvwm-themes-config --site --reset
	fvwm-themes-menuapp --site --build-menus --remove-popup

	use gnome && fvwm-themes-images --ft-install --gnome
}
