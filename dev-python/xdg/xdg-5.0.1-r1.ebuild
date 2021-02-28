# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Implementation of the XDG Base Directory Specification in Python"
HOMEPAGE="https://github.com/srstevenson/xdg https://pypi.org/project/xdg"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# https://bugs.gentoo.org/773415
RDEPEND="!dev-python/pyxdg[${PYTHON_USEDEP}]"
