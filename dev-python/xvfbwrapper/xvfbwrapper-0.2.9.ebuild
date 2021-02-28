# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Python wrapper for running a display inside X virtual framebuffer"
HOMEPAGE="https://github.com/cgoldberg/xvfbwrapper https://pypi.org/project/xvfbwrapper/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x11-base/xorg-server[xvfb]"

python_test() {
	"${PYTHON}" -m unittest discover || die "Tests failed with ${EPYTHON}"
}
