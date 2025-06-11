# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
inherit desktop distutils-r1 xdg

DESCRIPTION="Elegant GTK+ music client for the Music Player Daemon (MPD)"
HOMEPAGE="https://www.nongnu.org/sonata/"
SRC_URI="https://github.com/multani/sonata/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="dbus taglib"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/python-mpd2[${PYTHON_USEDEP}]
		dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
		taglib? ( dev-python/tagpy[${PYTHON_USEDEP}] )
	')
"
BDEPEND="virtual/pkgconfig"

distutils_enable_tests unittest

src_install() {
	distutils-r1_src_install
	doicon -s 128 sonata/pixmaps/sonata.png
	rm -r "${ED}"/usr/share/sonata || die
}
