# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 gnome2-utils xdg-utils

DESCRIPTION="Drop-down terminal for GNOME"
HOMEPAGE="https://github.com/Guake/guake https://pypi.org/project/Guake"
SRC_URI="mirror://pypi/G/${PN^}/${P^}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="utempter"

RDEPEND="
	dev-libs/glib
	dev-libs/keybinder:3[introspection]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pbr[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/libnotify[introspection]
	x11-libs/vte:2.91[introspection]
	utempter? ( sys-libs/libutempter )
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	gnome-base/gsettings-desktop-schemas
	sys-devel/gettext
	sys-devel/make
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3.2-paths.patch
	"${FILESDIR}"/${PN}-3.4.0-paths.patch
)
S=${WORKDIR}/${P^}

python_compile_all() {
	emake prepare-install prefix=/usr
	emake generate-paths prefix=/usr DATA_DIR='$(datadir)/guake' DEV_SCHEMA_DIR='$(gsettingsschemadir)'
	default
}

python_install_all() {
	emake install-schemas install-locale prefix=/usr DESTDIR="${D}"
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
