# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="A full-featured, hackable tiling window manager written in Python"
HOMEPAGE="http://qtile.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="test"

# requires internet and specific
# pulseaudio settings

RDEPEND="
	x11-libs/cairo[X,xcb(+)]
	x11-libs/pango
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	>=dev-python/cairocffi-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
	>=dev-python/xcffib-0.8.1[${PYTHON_USEDEP}]
	media-sound/pulseaudio
"

python_install_all() {
	local DOCS=( CHANGELOG README.rst )
	distutils-r1_python_install_all

	insinto /usr/share/xsessions
	doins resources/qtile.desktop

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN}
}
