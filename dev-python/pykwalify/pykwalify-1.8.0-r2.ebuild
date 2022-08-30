# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python lib/cli for JSON/YAML schema validation"
HOMEPAGE="https://pypi.org/project/pykwalify/ https://github.com/Grokzen/pykwalify"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86 ~amd64-linux ~x86-linux"

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
)
