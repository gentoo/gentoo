# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )

inherit distutils-r1

DESCRIPTION="A simple argparse wrapper"
HOMEPAGE="https://pythonhosted.org/argh/"
SRC_URI="mirror://pypi/a/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86"
LICENSE="LGPL-3"

BDEPEND="
	test? (
		dev-python/iocapture[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
