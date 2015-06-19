# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/xvfbwrapper/xvfbwrapper-0.2.4.ebuild,v 1.5 2015/04/08 08:05:20 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Python wrapper for running a display inside X virtual framebuffer"
HOMEPAGE="https://github.com/cgoldberg/xvfbwrapper
	http://pypi.python.org/pypi/xvfbwrapper"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="x11-base/xorg-server[xvfb]"
DEPEND="${RDEPEND}
	test? ( dev-python/pep8[${PYTHON_USEDEP}] )
"

python_test() {
#	"${PYTHON}" test_xvfb.py || die "Tests failed with ${EPYTHON}"
	"${PYTHON}" -m unittest discover || die "Tests failed with ${EPYTHON}"
}
