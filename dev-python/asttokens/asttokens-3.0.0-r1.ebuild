# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Annotate Python AST trees with source text and token information"
HOMEPAGE="
	https://github.com/gristlabs/asttokens/
	https://pypi.org/project/asttokens/
"
SRC_URI="
	https://github.com/gristlabs/asttokens/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/astroid[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

PATCHES=(
	# https://github.com/gristlabs/asttokens/pull/157
	"${FILESDIR}/${P}-py314.patch"
)
