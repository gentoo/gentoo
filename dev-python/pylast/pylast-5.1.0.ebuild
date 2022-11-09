# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Python interface to last.fm and other api-compatible websites"
HOMEPAGE="
	https://pypi.org/project/pylast/
	https://github.com/pylast/pylast/
"
SRC_URI="
	https://github.com/pylast/pylast/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	dev-python/httpx[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
