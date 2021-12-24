# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="GNOME hexadecimal editor"
HOMEPAGE="https://wiki.gnome.org/Apps/Ghex"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/ghex.git"
	SRC_URI=""
else
	MY_PV="4.alpha.1"
	SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/${MY_PV}/${PN}-${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~riscv ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="GPL-2+ FDL-1.1+"
SLOT="4"

RDEPEND="
	>=dev-libs/atk-1.0.0
	>=dev-libs/glib-2.31.10:2
	>=x11-libs/gtk+-3.3.8:3
	gui-libs/gtk:4
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
