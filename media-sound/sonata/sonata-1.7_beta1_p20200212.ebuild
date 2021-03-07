# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=0c807e593f7571a654ad055cb126652d7f3a698d
PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_SINGLE_IMPL="true"
DISTUTILS_USE_SETUPTOOLS="rdepend"
inherit desktop distutils-r1

DESCRIPTION="Elegant GTK+ music client for the Music Player Daemon (MPD)"
HOMEPAGE="https://www.nongnu.org/sonata/"
SRC_URI="https://github.com/multani/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="dbus taglib"

BDEPEND="
	virtual/pkgconfig"
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
		dev-python/python-mpd[${PYTHON_MULTI_USEDEP}]
		dbus? ( dev-python/dbus-python[${PYTHON_MULTI_USEDEP}] )
		taglib? ( dev-python/tagpy[${PYTHON_MULTI_USEDEP}] )
	')
"

S="${WORKDIR}/${PN}-${COMMIT}"

distutils_enable_tests unittest

src_install() {
	distutils-r1_src_install
	doicon -s 128 sonata/pixmaps/sonata.png
	rm -r "${ED}"/usr/share/sonata || die
}
