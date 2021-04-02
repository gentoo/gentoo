# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic git-r3 gnome2-utils toolchain-funcs

DESCRIPTION="Crayon Physics-like drawing puzzle game using the same excellent Box2D engine"
HOMEPAGE="https://thp.io/2015/numptyphysics/"
EGIT_REPO_URI="https://github.com/thp/numptyphysics"
# This is only the SRC_URI for the user levels. The code is in git repo.
SRC_URI="user-levels? (
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
IUSE="+user-levels"

RDEPEND="
	dev-libs/glib:2
	media-libs/libsdl2[opengl,video]
	media-libs/sdl2-image[png]
	media-libs/sdl2-ttf
	virtual/opengl
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.5-gentoo.patch
)

src_compile() {
	tc-export CC CXX
	emake
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
