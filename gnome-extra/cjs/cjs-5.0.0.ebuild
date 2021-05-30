# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit meson pax-utils python-any-r1 virtualx

DESCRIPTION="Linux Mint's fork of gjs for Cinnamon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/cjs"
SRC_URI="https://github.com/linuxmint/cjs/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
IUSE="+cairo examples gtk readline sysprof test"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-lang/spidermonkey:78
	>=dev-libs/glib-2.58.0:2
	>=dev-libs/gobject-introspection-1.58.3:=
	>=dev-libs/libffi-3.2.1:0=

	cairo? ( x11-libs/cairo[glib,X] )
	readline? ( sys-libs/readline:0= )
"
DEPEND="
	${RDEPEND}
	sysprof? ( >=dev-util/sysprof-capture-3.38.1:4 )
	test? (
		sys-apps/dbus

		gtk? ( x11-libs/gtk+:3[introspection] )
	)
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

src_prepare() {
	default
	python_fix_shebang build
}

src_configure() {
	local emesonargs=(
		$(meson_feature cairo)
		$(meson_feature readline)
		$(meson_feature sysprof profiler)
		-Dinstalled_tests=false
		$(meson_use !test skip_dbus_tests)
		$(meson_use !test skip_gtk_tests)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

src_install() {
	meson_src_install

	if use examples; then
		docinto examples
		dodoc "${S}"/examples/*
	fi

	# Required for cjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/cjs-console"
}
