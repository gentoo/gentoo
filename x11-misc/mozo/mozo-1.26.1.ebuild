# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="xml(+)"

inherit mate python-r1

DESCRIPTION="Mozo menu editor for MATE"
LICENSE="GPL-2+ GPL-3+ LGPL-2+ LGPL-2.1+"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-python/pygobject-3:3[${PYTHON_USEDEP}]
	>=mate-base/mate-menus-1.21.0[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/gtk+-3.22:3[introspection]
	!!x11-misc/mate-menu-editor
"

RDEPEND="${COMMON_DEPEND}
	virtual/libintl
"
DEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	mate_src_prepare
	python_copy_sources
}

src_configure() {
	python_foreach_impl run_in_build_dir mate_src_configure \
		--disable-icon-update
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_test() {
	python_foreach_impl run_in_build_dir emake check
}

src_install() {
	installing() {
		mate_src_install

		# Massage shebang to make python_doscript happy
		sed -e 's:#! '"${PYTHON}:#!/usr/bin/python:" \
			-i mozo || die

		python_doscript mozo
		python_optimize
	}

	python_foreach_impl run_in_build_dir installing
}
