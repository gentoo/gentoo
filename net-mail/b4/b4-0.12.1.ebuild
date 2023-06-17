# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Utility for fetching patchsets from public-inbox"
HOMEPAGE="https://pypi.org/project/b4/"
# pypi lacks tests
SRC_URI="https://git.kernel.org/pub/scm/utils/b4/b4.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/dkimpy-1.0[${PYTHON_USEDEP}]
	>=dev-python/dnspython-2.1[${PYTHON_USEDEP}]
	>=dev-python/patatt-0.6[${PYTHON_USEDEP}]
	>=dev-python/requests-2.24[${PYTHON_USEDEP}]
	>=dev-vcs/git-filter-repo-2.30[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
