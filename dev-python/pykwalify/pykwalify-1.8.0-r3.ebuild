# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python lib/cli for JSON/YAML schema validation"
HOMEPAGE="
	https://github.com/Grokzen/pykwalify/
	https://pypi.org/project/pykwalify/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/docopt-0.6.2[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.16.0[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/testfixtures[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.0-S.patch
	# fix tests for >=dev-python/ruamel-yaml-1.18, see #923136
	"${FILESDIR}"/${PN}-1.8.0-ruamel-yaml-1.18.patch
)
