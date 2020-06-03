# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} pypy3 )

inherit distutils-r1

DESCRIPTION="A simple argparse wrapper"
HOMEPAGE="https://pythonhosted.org/argh/"
SRC_URI="mirror://pypi/a/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc x86"
LICENSE="LGPL-3"

BDEPEND="
	test? (
		dev-python/iocapture[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
