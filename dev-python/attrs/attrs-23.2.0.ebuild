# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Attributes without boilerplate"
HOMEPAGE="
	https://github.com/python-attrs/attrs/
	https://attrs.readthedocs.io/
	https://pypi.org/project/attrs/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

BDEPEND="
	>=dev-python/hatch-fancy-pypi-readme-23.2.0[${PYTHON_USEDEP}]
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/cloudpickle[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/zope-interface[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/python-attrs/attrs/pull/1249
	"${FILESDIR}/${P}-pytest-8.patch"
	# https://github.com/python-attrs/attrs/pull/1255
	"${FILESDIR}/${P}-py313.patch"
)
