# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 pypi

DESCRIPTION="Simple SQLite-based object store"
HOMEPAGE="https://thp.io/2010/minidb/"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

distutils_enable_tests pytest
