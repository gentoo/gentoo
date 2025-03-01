# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( pypy3 python3_{10..13} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 pypi

DESCRIPTION="A Python wrapper for the MediaInfo library"
HOMEPAGE="
	https://github.com/sbraz/pymediainfo/
	https://pypi.org/project/pymediainfo/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	media-libs/libmediainfo
"
# tests/test_pymediainfo.py::MediaInfoURLTest::test_parse_url requires libmediainfo with curl support
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		media-libs/libmediainfo[curl]
	)
"

distutils_enable_sphinx docs dev-python/alabaster dev-python/myst-parser
distutils_enable_tests pytest
