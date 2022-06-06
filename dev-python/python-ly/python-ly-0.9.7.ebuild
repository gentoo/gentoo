# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Tool and library for manipulating LilyPond files"
HOMEPAGE="https://github.com/frescobaldi/python-ly https://pypi.org/project/python-ly/"
# No tests in pypi tarball
SRC_URI="https://github.com/frescobaldi/python-ly/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

RESTRICT="test"

distutils_enable_tests pytest
