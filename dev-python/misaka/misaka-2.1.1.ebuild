# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A CFFI binding for Hoedown, a markdown parsing library"
HOMEPAGE="http://misaka.61924.nl/ https://github.com/FSX/misaka"
SRC_URI="https://github.com/FSX/misaka/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="MIT"
SLOT="0"

RDEPEND="dev-python/cffi[${PYTHON_USEDEP}]"

# FIXME: tests requires write access outside sandbox
#distutils_enable_tests setup.py
