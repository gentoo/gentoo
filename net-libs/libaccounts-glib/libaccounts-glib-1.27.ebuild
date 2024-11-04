# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit meson python-r1 vala

DESCRIPTION="Accounts SSO (Single Sign-On) management library for GLib applications"
HOMEPAGE="https://gitlab.com/accounts-sso/libaccounts-glib"
SRC_URI="https://gitlab.com/accounts-sso/${PN}/-/archive/VERSION_${PV}/${PN}-VERSION_${PV}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${PN}-VERSION_${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="doc test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

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
	dev-util/gdbus-codegen
	dev-util/glib-utils
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
	test? (
		dev-libs/check
		dev-util/dbus-test-runner
	)
"

src_prepare() {
	default
	vala_setup --ignore-use

	use doc || sed -e "/^subdir('docs')$/d" -i meson.build || die
	use test || sed -e "/^subdir('tests')$/d" -i meson.build || die

	# /tmp isn't accessible from sandbox
	sed -i -e "s|/tmp/\(.*\)|${T}/\1|" tests/check_ag.c || die
	sed -i -e "s|/tmp|${T}|" tests/meson.build || die
}

src_configure() {
	my_configure() {
		local emesonargs=(
			-Dinstall-py-overrides=true
		)
		meson_src_configure
	}
	python_foreach_impl run_in_build_dir my_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir meson_src_compile
}

src_test() {
	python_foreach_impl run_in_build_dir meson_src_test
}

src_install() {
	einstalldocs
	python_foreach_impl run_in_build_dir meson_src_install
	python_foreach_impl python_optimize
}
