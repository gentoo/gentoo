# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit meson python-r1 vala vcs-snapshot

DESCRIPTION="GLib binding for the D-Bus API provided by signond"
HOMEPAGE="https://01.org/gsso/"
SRC_URI="https://gitlab.com/accounts-sso/${PN}/-/archive/VERSION_${PV}/${PN}-VERSION_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="debug doc +introspection python test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} introspection )"

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
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	doc? ( dev-util/gtk-doc )
	test? ( dev-libs/check )
"

# needs more love
RESTRICT="test"

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

src_compile() {
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
	else
		meson_src_install
	fi
}
