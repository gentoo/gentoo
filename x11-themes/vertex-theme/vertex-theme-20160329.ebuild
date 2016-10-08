# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Vertex theme for GTK+ based desktops"
HOMEPAGE="https://github.com/horst3180/vertex-theme"
SRC_URI="https://github.com/horst3180/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cinnamon gnome-shell mate xfce"

RDEPEND="
	x11-themes/gnome-themes-standard
	x11-themes/gtk-engines-murrine
	cinnamon? ( >=x11-libs/gtk+-3.20:3 )
	gnome-shell? ( >=x11-libs/gtk+-3.20:3 )
"
DEPEND="
	virtual/pkgconfig
"

PATCHES=(
	# Do not let configure try to figure out gtk+:3 version installed
	# See also https://github.com/horst3180/arc-theme/issues/436 and 484
	"${FILESDIR}"/configure-gtk3-version.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-unity \
		--enable-gtk2 \
		--enable-gtk3 \
		--with-gnome=3.20 \
		$(use_enable cinnamon) \
		$(use_enable gnome-shell) \
		$(use_enable mate metacity) \
		$(use_enable xfce xfwm)
}
