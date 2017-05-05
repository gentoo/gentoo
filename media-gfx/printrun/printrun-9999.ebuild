# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="GUI interface for 3D printing on RepRap and other printers"
HOMEPAGE="https://github.com/kliment/Printrun"
EGIT_REPO_URI="https://github.com/kliment/Printrun.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-python/pyserial
	dev-python/wxpython:2.8
	dev-python/pyglet
	dev-python/dbus-python
	media-gfx/cairosvg"
RDEPEND="${DEPEND}"
