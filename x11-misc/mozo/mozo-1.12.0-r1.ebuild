# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit python-r1 mate

SRC_URI="${SRC_URI} gtk3? ( https://dev.gentoo.org/~np-hardass/distfiles/${PN}/${P}-gtk3.patch.bz2 )"
KEYWORDS="~amd64 ~arm ~x86"

DESCRIPTION="Mozo menu editor for MATE"
LICENSE="GPL-2"
SLOT="0"

IUSE="gtk3"

RDEPEND="${PYTHON_DEPS}
	>=mate-base/mate-menus-1.6[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	virtual/libintl:0
	!!x11-misc/mate-menu-editor
	!gtk3? (
		>=dev-python/pygobject-2.15.1:2[${PYTHON_USEDEP}]
		>=dev-python/pygtk-2.13:2[${PYTHON_USEDEP}]
		>=mate-base/mate-menus-1.6[python]
		x11-libs/gtk+:2[introspection]
	)
	gtk3? (
		>=dev-python/pygobject-3:3[${PYTHON_USEDEP}]
		x11-libs/gtk+:3[introspection]
	)"

DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40:*
	sys-devel/gettext:*
	virtual/pkgconfig:*"

src_prepare() {
	if use gtk3; then
		eapply "${WORKDIR}/${P}-gtk3.patch"
		MATE_FORCE_AUTORECONF=true
	fi
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
