# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 gnome2-utils plocale virtualx xdg

PLOCALES="ca cs de el es fa fi fr gl hr hu id it ja ko nb nl pa pl pt_BR ru sv tr uk zh_CN zh_TW"

DESCRIPTION="Drop-down terminal for GNOME"
HOMEPAGE="http://guake-project.org/"
SRC_URI="https://github.com/Guake/guake/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~ppc64 ~x86"
IUSE="utempter"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]')
	dev-libs/keybinder:3[introspection]
	x11-libs/libnotify[introspection]
	x11-libs/libwnck:3[introspection]
	x11-libs/vte:2.91[introspection]
	utempter? ( sys-libs/libutempter )"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools_scm[${PYTHON_USEDEP}]
		test? (
			dev-python/pyfakefs[${PYTHON_USEDEP}]
			dev-python/pytest-mock[${PYTHON_USEDEP}]
		)')
	dev-libs/glib:2
	gnome-base/gsettings-desktop-schemas
	sys-devel/gettext"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV} # needed with github's tarball

	local po=($(plocale_get_locales disabled))
	po=("${po[@]/%/.po}")
	(( ! ${#po[@]} )) || rm "${po[@]/#/po/}" || die

	emake PREFIX="${EPREFIX}"/usr prepare-install # paths.py.in -> paths.py
}

python_test() {
	# - uses /usr/bin/bash if SHELL is not exported
	# - pytest-xvfb fails with Terminated, virtx alone works
	SHELL=${SHELL} virtx epytest -p no:xvfb
}

python_install() {
	# use right schema/data dirs, done here so tests don't use the system's
	sed -e "/^SCHEMA_DIR/s|=.*|= \"${EPREFIX}/usr/share/glib-2.0/schemas\"|" \
		-e "/def get_default_data_dir/{n;s|=.*|= \"${EPREFIX}/usr/share/guake\"|}" \
		-i "${BUILD_DIR}/install$(python_get_sitedir)"/guake/paths.py || die

	distutils-r1_python_install
}

python_install_all() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install-{locale,schemas}

	dodoc NEWS.rst README.rst
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
