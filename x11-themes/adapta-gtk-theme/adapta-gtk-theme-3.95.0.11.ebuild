# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="An adaptive Gtk+ theme based on Material Design Guidelines"
HOMEPAGE="https://github.com/adapta-project/adapta-gtk-theme"
SRC_URI="https://github.com/adapta-project/adapta-gtk-theme/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 x86"

src_prepare(){
	default
	eautoreconf
}

DEPEND="dev-lang/sassc
	dev-libs/glib:2
	dev-ruby/sass:*
	media-gfx/inkscape
	x11-libs/gdk-pixbuf:2"

RDEPEND="${DEPEND}"

BDEPEND="virtual/pkgconfig"
