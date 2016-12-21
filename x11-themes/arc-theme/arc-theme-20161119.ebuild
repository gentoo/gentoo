# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="A flat theme with transparent elements for GTK+3, GTK+2 and GNOME Shell"
HOMEPAGE="https://github.com/horst3180/arc-theme"
SRC_URI="https://github.com/horst3180/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cinnamon gnome-shell +gtk2 +gtk3 mate xfce"

# Supports various GTK+3 versions and uses pkg-config to determine which
# set of files to install. Updates will break it but only this fix will
# help. https://github.com/horst3180/arc-theme/pull/436
DEPEND="gtk3? ( >=x11-libs/gtk+-3.14:3
	virtual/pkgconfig )"

# gnome-themes-standard is only needed by GTK+2 for the Adwaita
# engine. This engine is built into GTK+3.
RDEPEND="gtk2? ( x11-themes/gnome-themes-standard
	x11-themes/gtk-engines-murrine )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-unity \
		$(use_enable cinnamon) \
		$(use_enable gtk2) \
		$(use_enable gtk3) \
		$(use_enable gnome-shell) \
		$(use_enable mate metacity) \
		$(use_enable xfce xfwm)
}
