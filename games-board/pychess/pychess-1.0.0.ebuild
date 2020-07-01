# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=no
PYTHON_REQ_USE="sqlite"

inherit xdg distutils-r1

DESCRIPTION="A chess client for GNOME"
HOMEPAGE="https://github.com/pychess/pychess"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gstreamer"

DEPEND="
	$(python_gen_cond_dep '
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP},sqlite]
		dev-python/websockets[${PYTHON_USEDEP}]
	')
	gnome-base/librsvg:2
	x11-libs/gtksourceview:3.0
	x11-libs/pango
	x11-themes/adwaita-icon-theme
	gstreamer? (
		$(python_gen_cond_dep '
			dev-python/gst-python:1.0[${PYTHON_USEDEP}]
		')
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-setup-no-display.patch
	"${FILESDIR}"/${PN}-gtk-compat.patch
)

src_install() {
	distutils-r1_src_install

	mv -v "${ED}"/usr/share/{appdata,metainfo} || die
	gunzip -v "${ED}"/usr/share/man/man1/${PN}.1.gz || die
}
