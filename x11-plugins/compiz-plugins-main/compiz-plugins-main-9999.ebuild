# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils git-r3

DESCRIPTION="Compiz Window Manager: Plugins"
HOMEPAGE="https://github.com/compiz-reloaded"
EGIT_REPO_URI="https://github.com/compiz-reloaded/compiz-plugins-main.git"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	gnome-base/librsvg
	virtual/jpeg:0
	virtual/glu
	>=x11-libs/compiz-bcop-${PV}
	>=x11-wm/compiz-${PV}
	x11-libs/cairo
"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_prepare(){
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-fast-install \
		--disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
