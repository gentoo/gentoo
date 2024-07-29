# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )
inherit gnome.org gnome2-utils meson python-any-r1 xdg vala

DESCRIPTION="Turn off all the lights"
HOMEPAGE="https://gitlab.gnome.org/GNOME/lightsoff"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"

RDEPEND="
	>=dev-libs/glib-2.38.0:2
	>=x11-libs/gtk+-3.24.0:3
	>=gnome-base/librsvg-2.32.0:2
"
DEPEND="${RDEPEND}"
# libxml2:2 needed for glib-compile-resources xml-stripblanks attributes
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
	gnome-base/librsvg:2[vala]
"

src_prepare() {
	default
	vala_setup

	# Bug #778845
	sed -i \
		-e 's:40\.rc:40~rc:' \
		-e 's:40\.beta:40~beta:' \
		-e 's:40\.alpha:40~alpha:' \
		data/org.gnome.LightsOff.appdata.xml.in || die
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
