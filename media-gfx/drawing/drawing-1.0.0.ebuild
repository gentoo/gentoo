# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit gnome2-utils meson python-single-r1 xdg

DESCRIPTION="A drawing application for the GNOME desktop"
HOMEPAGE="https://github.com/maoschanz/drawing"

if [[ "${PV}" == 9999 ]]
then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/maoschanz/${PN}.git"
else
	SRC_URI="https://github.com/maoschanz/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/glib
	dev-libs/appstream-glib[introspection]
	dev-python/pygobject[cairo]
"
DEPEND="
	dev-util/itstool
	${RDEPEND}
"

src_prepare() {
	sed -i -e '7,10d' "${S}/help/meson.build" || die
	default
}

pkg_preinst() {
	gnome2_schemas_savelist
	xdg_environment_reset
}

pkg_postinst() {
	gnome2_gconf_install
	gnome2_schemas_update
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	gnome2_gconf_uninstall
	gnome2_schemas_update
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
