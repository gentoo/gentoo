# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="A standalone Python library for working with git-bug repositories"
HOMEPAGE="
	https://git.kernel.org/pub/scm/utils/ezgb/ezgb.git/
	https://pypi.org/project/ezgb/
"
SRC_URI="https://git.kernel.org/pub/scm/utils/ezgb/ezgb.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/pygit2-1.19.3[${PYTHON_USEDEP}]
	dev-util/git-bug
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
