# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python JSONPath Next-Generation"
HOMEPAGE="
	https://github.com/h2non/jsonpath-ng/
	https://pypi.org/project/jsonpath-ng/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~x86"

RDEPEND="
	dev-python/ply[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/oslotest[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# unbundle ply (sigh)
	rm -r jsonpath_ng/_ply || die
	sed -i -e 's:jsonpath_ng[.]_ply:ply:' jsonpath_ng/*.py || die
	sed -i -e '/packages/d' setup.py || die
}
