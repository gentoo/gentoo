# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="sqlite"
inherit distutils-r1 xdg

DESCRIPTION="GTK chess client"
HOMEPAGE="https://pychess.github.io/"
SRC_URI="https://github.com/pychess/pychess/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="gstreamer"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP},cairo]
		>=dev-python/sqlalchemy-2[${PYTHON_USEDEP},sqlite]
		dev-python/websockets[${PYTHON_USEDEP}]
		gstreamer? ( dev-python/gst-python:1.0[${PYTHON_USEDEP}] )
	')
	gnome-base/librsvg:2[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/gtksourceview:3.0[introspection]
	x11-libs/pango[introspection]
	x11-themes/adwaita-icon-theme
"
BDEPEND="${RDEPEND}" # setup.py fails if introspection deps not found

PATCHES=(
	"${FILESDIR}"/${P}-python3.13.patch
)

src_install() {
	distutils-r1_src_install

	# https://github.com/pychess/pychess/pull/1825
	gunzip -v "${ED}"/usr/share/man/man1/${PN}.1.gz || die
}
