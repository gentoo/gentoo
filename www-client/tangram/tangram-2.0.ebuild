# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson xdg

DESCRIPTION="Web browser designed to organize and run Web applications"
HOMEPAGE="https://apps.gnome.org/app/re.sonny.Tangram/
	https://github.com/sonnyp/Tangram/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sonnyp/${PN^}.git"
else
	SRC_URI="https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	dev-libs/gjs
	gui-libs/gtk:4
	gui-libs/libadwaita:1
	net-libs/webkit-gtk:5
"
BDEPEND="
	${RDEPEND}
	dev-libs/appstream-glib
	dev-util/blueprint-compiler
	dev-util/desktop-file-utils
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0-dont-validate-appstream.patch
	"${FILESDIR}"/${PN}-2.0-meson-blueprint-compiler.patch
)

DOCS=( README.md TODO.md )

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}
