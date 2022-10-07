# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit meson python-r1 vala

DESCRIPTION="Accounts SSO (Single Sign-On) management library for GLib applications"
HOMEPAGE="https://gitlab.com/accounts-sso/libaccounts-glib"
SRC_URI="https://gitlab.com/accounts-sso/${PN}/-/archive/VERSION_${PV}/${PN}-VERSION_${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-VERSION_${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv x86"
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
# fails
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/gobject-introspection:=
	dev-libs/libxml2
	dev-python/pygobject:3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	dev-libs/check
	dev-util/gdbus-codegen
	dev-util/glib-utils
	doc? ( dev-util/gtk-doc )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.25-assert-failure.patch"
	"${FILESDIR}/${P}-project-version.patch"
)

src_prepare() {
	default
	vala_setup --ignore-use

	use doc || sed -e "/^subdir('docs')$/d" -i meson.build || die
}

src_configure() {
	python_foreach_impl run_in_build_dir meson_src_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir meson_src_compile
}

src_install() {
	einstalldocs
	python_foreach_impl run_in_build_dir meson_src_install
	python_foreach_impl python_optimize
}
