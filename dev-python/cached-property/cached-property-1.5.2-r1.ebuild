# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} pypy3 )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="A cached-property for decorating methods in classes"
HOMEPAGE="https://github.com/pydanny/cached-property"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~riscv x86"

BDEPEND="test? ( dev-python/freezegun[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

DOCS=( README.rst HISTORY.rst CONTRIBUTING.rst AUTHORS.rst )

PATCHES=(
	# bug 638250
	"${FILESDIR}"/${PN}-1.5.1-test-failure.patch
	# @asyncio.coroutine removed in py3.11
	"${FILESDIR}"/${PN}-1.5.2-python311.patch
)
