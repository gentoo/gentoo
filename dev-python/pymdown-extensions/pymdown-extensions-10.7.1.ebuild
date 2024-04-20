# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Extensions for Python Markdown"
HOMEPAGE="
	https://github.com/facelessuser/pymdown-extensions/
	https://pypi.org/project/pymdown-extensions/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/markdown-3.5[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		>=dev-python/pygments-2.12.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		# https://github.com/facelessuser/pymdown-extensions/issues/2343
		"${FILESDIR}/${P}-md36.patch"
	)

	# broken on pypy3; unfortunately, the parametrization is based
	# on indexes and these are pretty random, so we need to remove it
	# entirely
	# TODO: restore it when pypy with a fix is in Gentoo
	# https://github.com/pypy/pypy/issues/4920
	rm "tests/extensions/superfences/superfences (normal).txt" || die
	distutils-r1_src_prepare
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
