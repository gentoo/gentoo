# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_P="${P/-/_}"
DESCRIPTION="Checks PyPI validity of reStructuredText"
HOMEPAGE="https://pypi.org/project/restructuredtext-lint/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN/-/_}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

RDEPEND="
	>=dev-python/docutils-0.11[${PYTHON_USEDEP}]
	<dev-python/docutils-1.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
