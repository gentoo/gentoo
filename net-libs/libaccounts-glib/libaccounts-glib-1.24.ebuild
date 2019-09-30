# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit meson python-r1 vala vcs-snapshot

DESCRIPTION="Accounts SSO (Single Sign-On) management library for GLib applications"
HOMEPAGE="https://01.org/gsso/"
SRC_URI="https://gitlab.com/accounts-sso/${PN}/-/archive/VERSION_${PV}/${PN}-VERSION_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/gobject-introspection:=
	dev-libs/libxml2
	dev-python/pygobject:3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-libs/check
	doc? ( dev-util/gtk-doc )
"

# fails
RESTRICT="test"

src_prepare() {
	default

	vala_src_prepare

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
}
