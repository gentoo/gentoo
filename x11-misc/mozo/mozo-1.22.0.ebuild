# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="xml"

inherit python-r1 mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="Mozo menu editor for MATE"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-python/pygobject-3:3[${PYTHON_USEDEP}]
	>=mate-base/mate-menus-1.21.0[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/gtk+-3.22:3[introspection]
	virtual/libintl
	!!x11-misc/mate-menu-editor"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	sys-devel/gettext:*
	virtual/pkgconfig:*"

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
	}

	python_foreach_impl run_in_build_dir installing
}
