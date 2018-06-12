# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils gnome2-utils flag-o-matic

DESCRIPTION="Crayon Physics-like drawing puzzle game using the same excellent Box2D engine"
HOMEPAGE="http://thp.io/2015/numptyphysics/"

# This is only the SRC_URI for the user levels. The code is in git repo.
SRC_URI="user-levels? (
	https://github.com/thp/numptyphysics/archive/0.3.4.tar.gz -> ${P}.tar.gz
	http://numptyphysics.garage.maemo.org/levels/butelo/butelo.npz
	http://numptyphysics.garage.maemo.org/levels/catalyst/catalyst.npz
	http://numptyphysics.garage.maemo.org/levels/christeck/christeck.npz
	http://numptyphysics.garage.maemo.org/levels/dneary/dneary.npz
	http://numptyphysics.garage.maemo.org/levels/gnuton/gnuton.npz
	http://numptyphysics.garage.maemo.org/levels/gudger/gudger.npz
	http://numptyphysics.garage.maemo.org/levels/guile/guile.npz
	http://numptyphysics.garage.maemo.org/levels/hurd/hurd.npz
	http://numptyphysics.garage.maemo.org/levels/ioan/ioan.npz
	http://numptyphysics.garage.maemo.org/levels/jhoff80/jhoff80.npz
	http://numptyphysics.garage.maemo.org/levels/leonet/leonet.npz
	http://numptyphysics.garage.maemo.org/levels/melvin/melvin.npz
	http://numptyphysics.garage.maemo.org/levels/noodleman/noodleman.npz
	http://numptyphysics.garage.maemo.org/levels/papky/papky.npz
	http://numptyphysics.garage.maemo.org/levels/perli/perli.npz
	http://numptyphysics.garage.maemo.org/levels/qole/qole.npz
	http://numptyphysics.garage.maemo.org/levels/siminz/siminz.npz
	http://numptyphysics.garage.maemo.org/levels/szymanowski/szymanowski.npz
	http://numptyphysics.garage.maemo.org/levels/therealbubba/therealbubba.npz
	http://numptyphysics.garage.maemo.org/levels/werre/werre.npz
	http://numptyphysics.garage.maemo.org/levels/zeez/zeez.npz
)"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+user-levels"

RDEPEND="
	media-libs/libsdl2[opengl,video]
	media-libs/sdl2-image[png]
	media-libs/sdl2-ttf
	virtual/opengl
	dev-libs/glib:2
"
DEPEND="${DEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	append-cxxflags -std=c++11 -Isrc
	eapply "${FILESDIR}"/${P}-gentoo.patch
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
