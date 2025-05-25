# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Dependency injection framework designed with Python in mind"
HOMEPAGE="
	https://github.com/ikalnytskyi/picobox/
	https://pypi.org/project/picobox/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/flask[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
