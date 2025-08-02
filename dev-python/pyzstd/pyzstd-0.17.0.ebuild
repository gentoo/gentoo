# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_UPSTREAM_PEP517=standalone
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings to Zstandard (zstd) compression library"
HOMEPAGE="
	https://github.com/Rogdham/pyzstd/
	https://pypi.org/project/pyzstd/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 arm64 ~x86"

DEPEND="
	app-arch/zstd:=
"
RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.11 3.12)
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

src_prepare() {
	sed -i "s/'-g0', '-flto'//" setup.py || die

	distutils-r1_src_prepare

	DISTUTILS_ARGS=(
		--dynamic-link-zstd
		--multi-phase-init
	)
}

python_test() {
	eunittest tests
}
