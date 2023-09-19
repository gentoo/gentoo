# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="LZ4 Bindings for Python"
HOMEPAGE="
	https://github.com/python-lz4/python-lz4/
	https://pypi.org/project/lz4/
"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 arm arm64 ~riscv x86 ~amd64-linux ~x86-linux"

DEPEND="
	app-arch/lz4:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/pkgconfig[${PYTHON_USEDEP}]
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# lz4.stream is not officially supported and not installed by default
	# (we do not support installing it at the moment)
	tests/stream
)
