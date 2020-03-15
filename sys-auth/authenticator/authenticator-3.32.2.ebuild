# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="sqlite"

inherit gnome2-utils meson python-single-r1 virtualx xdg-utils

DESCRIPTION="Two-factor authentication code generator for GNOME"
HOMEPAGE="https://gitlab.gnome.org/World/Authenticator"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.gnome.org/World/Authenticator"
else
	SRC_URI="https://gitlab.gnome.org/World/Authenticator/-/archive/${PV}/Authenticator-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"

	S="${WORKDIR}/Authenticator-${PV}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="gnome-shell test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

COMMON_DEPEND="${PYTHON_DEPS}
	app-crypt/libsecret[introspection]
	gui-libs/libhandy:=[introspection]
	x11-libs/gtk+:3[introspection]
	$(python_gen_cond_dep '
		dev-python/beautifulsoup:4[${PYTHON_MULTI_USEDEP}]
		dev-python/pillow[${PYTHON_MULTI_USEDEP}]
		dev-python/pyfavicon[${PYTHON_MULTI_USEDEP}]
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
		dev-python/pyotp[${PYTHON_MULTI_USEDEP}]
		dev-python/pyzbar[${PYTHON_MULTI_USEDEP}]
		dev-python/yoyo-migrations[${PYTHON_MULTI_USEDEP}]
	')"

BDEPEND="dev-libs/appstream-glib"
RDEPEND="${COMMON_DEPEND}
	gnome-shell? ( gnome-base/gnome-shell )"
DEPEND="${COMMON_DEPEND}
	test? ( x11-apps/xhost )"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	python_fix_shebang "${S}"
}

src_install() {
	meson_src_install
	python_optimize "${ED}"/usr
}

pkg_preinst() {
	gnome2_schemas_savelist
}

src_test() {
	xdg_environment_reset
	virtx meson_src_test
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
	xdg_desktop_database_update
}
