# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 gnome2

DESCRIPTION="Mass rename files"
HOMEPAGE="http://www.infinicode.org/code/pyrenamer/"
SRC_URI="http://www.infinicode.org/code/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="music"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# TODO: Missing support for >=dev-python/eyeD3-0.7.x API that could
# be used as alternative to app-misc/hachoir-metadata with || ( )
RDEPEND="${PYTHON_DEPS}
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	dev-python/gconf-python[${PYTHON_USEDEP}]
	music? ( app-misc/hachoir-metadata[${PYTHON_USEDEP}] )"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	python_fix_shebang .
	gnome2_src_prepare
}
