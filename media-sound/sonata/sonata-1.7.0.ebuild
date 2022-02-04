# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_SINGLE_IMPL="true"
DISTUTILS_USE_SETUPTOOLS="rdepend"
inherit desktop distutils-r1 xdg

DESCRIPTION="Elegant GTK+ music client for the Music Player Daemon (MPD)"
HOMEPAGE="https://www.nongnu.org/sonata/"
SRC_URI="https://github.com/multani/sonata/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="dbus taglib"

BDEPEND="
	virtual/pkgconfig"
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/python-mpd[${PYTHON_USEDEP}]
		dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
		taglib? ( dev-python/tagpy[${PYTHON_USEDEP}] )
	')
"

distutils_enable_tests unittest

src_install() {
	distutils-r1_src_install
	doicon -s 128 sonata/pixmaps/sonata.png
	rm -r "${ED}"/usr/share/sonata || die
}
