# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Wrapper around re or regex that adds additional back references"
HOMEPAGE="
	https://github.com/facelessuser/backrefs/
	https://pypi.org/project/backrefs/
"
SRC_URI="
	https://github.com/facelessuser/backrefs/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/regex[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

distutils_enable_tests pytest
