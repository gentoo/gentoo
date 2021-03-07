# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 gnome2-utils xdg-utils

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Guake/guake.git"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="Drop-down terminal for GNOME"
HOMEPAGE="
	https://github.com/Guake/guake/
	https://pypi.org/project/guake/"

LICENSE="GPL-2"
SLOT="0"
IUSE="utempter"

RDEPEND="
	dev-libs/glib
	dev-libs/keybinder:3[introspection]
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_MULTI_USEDEP}]
		dev-python/pbr[${PYTHON_MULTI_USEDEP}]
		dev-python/pycairo[${PYTHON_MULTI_USEDEP}]
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
	')
	x11-libs/libnotify[introspection]
	x11-libs/libwnck:3[introspection]
	x11-libs/vte:2.91[introspection]
	utempter? ( sys-libs/libutempter )"
DEPEND="${RDEPEND}"
BDEPEND="
	gnome-base/gsettings-desktop-schemas
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3.2-paths.patch
)

python_compile_all() {
	emake prepare-install PREFIX=/usr
	emake generate-paths PREFIX=/usr DATA_DIR='$(datadir)/guake' DEV_SCHEMA_DIR='$(gsettingsschemadir)'
	default
}

python_install_all() {
	emake install-schemas install-locale PREFIX=/usr DESTDIR="${D}"
	distutils-r1_python_install_all
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_desktop_database_update
}
