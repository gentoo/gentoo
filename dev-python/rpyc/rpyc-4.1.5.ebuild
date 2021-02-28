# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Remote Python Call (RPyC), a transparent and symmetric RPC library"
HOMEPAGE="https://rpyc.readthedocs.io/en/latest/"
SRC_URI="https://github.com/tomerfiliba-org/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/plumbum[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
