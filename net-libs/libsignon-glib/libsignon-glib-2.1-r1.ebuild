# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )
inherit meson python-r1 vala

DESCRIPTION="GLib binding for the D-Bus API provided by signond"
HOMEPAGE="https://accounts-sso.gitlab.io/"
SRC_URI="https://gitlab.com/accounts-sso/${PN}/-/archive/VERSION_${PV}/${PN}-VERSION_${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-VERSION_${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"
IUSE="debug doc +introspection python test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} introspection )"
# needs more love
RESTRICT="test"

RDEPEND="
	dev-libs/glib:2
	net-libs/signond
	introspection? ( dev-libs/gobject-introspection:= )
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="$(python_gen_any_dep)
	$(vala_depend)
	dev-util/gdbus-codegen
	dev-util/glib-utils
	doc? ( dev-util/gtk-doc )
	test? ( dev-libs/check )
"

python_check_deps() { return 0; }

pkg_setup() {
	python_setup
}

src_prepare() {
	default
	vala_src_prepare

	use doc || sed -e "/^subdir('docs')$/d" -i meson.build || die

	cp libsignon-glib/*.xml libsignon-glib/interfaces || die
}

src_configure() {
	myconfigure() {
		local emesonargs=(
			-Ddebugging=$(usex debug true false)
			-Dintrospection=$(usex introspection true false)
			-Dpython=$(usex python true false)
			-Dtests=$(usex test true false)
		)

		meson_src_configure
	}

	if use python; then
		python_foreach_impl run_in_build_dir myconfigure
	else
		myconfigure
	fi
}

src_compile() {
	if use python; then
		python_foreach_impl run_in_build_dir meson_src_compile
	else
		meson_src_compile
	fi
}

src_test() {
	if use python; then
		python_foreach_impl run_in_build_dir meson_src_test
	else
		meson_src_test
	fi
}

src_install() {
	einstalldocs

	if use python; then
		python_foreach_impl run_in_build_dir meson_src_install
		python_foreach_impl python_optimize
	else
		meson_src_install
	fi
}
