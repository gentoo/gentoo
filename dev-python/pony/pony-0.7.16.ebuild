# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python ORM with beautiful query syntax"
HOMEPAGE="
	https://ponyorm.org/
	https://github.com/ponyorm/pony/"
SRC_URI="
	https://github.com/ponyorm/pony/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]"
BDEPEND="test? ( $(python_gen_impl_dep sqlite) )"

distutils_enable_tests unittest
