# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 pypi

DESCRIPTION="A wrapper around the mediainfo library"
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

distutils_enable_sphinx docs dev-python/alabaster
distutils_enable_tests pytest
