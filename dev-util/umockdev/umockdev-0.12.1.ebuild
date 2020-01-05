# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit multilib-minimal python-any-r1

DESCRIPTION="Mock hardware devices for creating unit tests"
HOMEPAGE="https://github.com/martinpitt/umockdev/"
SRC_URI="https://github.com/martinpitt/umockdev/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/libudev:=[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.32:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.32:= )
"
DEPEND="${RDEPEND}
	test? (
		${PYTHON_DEPS}
		dev-libs/libgudev:=[${MULTILIB_USEDEP}] )
	app-arch/xz-utils
	>=dev-util/gtk-doc-am-1.14
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

# Tests seem to hang forever
# RESTRICT="test"

multilib_src_configure() {
	local ECONF_SOURCE="${S}"
	econf \
		--disable-gtk-doc \
		$(multilib_native_use_enable introspection) \
		$(use_enable static-libs static) \
		VALAC="$(type -P true)"
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
