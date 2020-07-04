# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Reliable machine-readable Linux distribution information for Python"
HOMEPAGE="https://distro.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 arm ~arm64 ~ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"

RESTRICT="test" # incomplete test resources
#distutils_enable_tests pytest
