# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit eutils fdo-mime gnome2-utils python-single-r1

MY_PV=${PV#0.}
MY_PV=${MY_PV/_rc/-RC}
MY_PN=Cura
SRC_URI="https://github.com/daid/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
DESCRIPTION="A mesh slicer written in python to produce gcode for 3D printers"
HOMEPAGE="https://github.com/daid/Cura"
LICENSE="AGPL-3"
SLOT="0"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	dev-python/wxpython:3.0[opengl,${PYTHON_USEDEP}]
	>=dev-python/numpy-1.6.2[${PYTHON_USEDEP}]
	>=dev-python/pyopengl-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/pyserial-2.6[${PYTHON_USEDEP}]
	>=media-gfx/curaengine-${PV}
"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-0.6.34[${PYTHON_USEDEP}]"

REQUIRED_USE="${PYTHON_REQ_USE}"
PATCHES=( "${FILESDIR}/${PN}-0.15.04.4-nopower.patch" )
S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_prepare() {
	cat > "${T}"/cura <<- CURAEOF || die
		#!/bin/sh
		PYTHONPATH="\$PYTHONPATH:${EPREFIX}/usr/share/cura/" "${PYTHON}" "${EPREFIX}/usr/share/cura/cura.py" "\$@"
	CURAEOF

	default
}

src_install() {
	insinto /usr/share/cura
	doins -r Cura resources plugins scripts/linux/cura.py
	newicon "${S}/resources/images/c.png" "cura.png"
	echo ${PV} > "${ED}"usr/share/cura/version || die
	dobin "${T}"/cura

	python_optimize $(find "${ED}" -name '*.py' -exec dirname \{\} + | sort -u)
}

pkg_preinst() {
	gnome2_icon_savelist

	make_desktop_entry cura \
		Cura \
		"${EPREFIX}/usr/share/pixmaps/cura.png" \
		"Graphics;3DGraphics;Engineering;Development"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
