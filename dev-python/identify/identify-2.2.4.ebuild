# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="File identification library for Python"
HOMEPAGE="https://github.com/pre-commit/identify"
SRC_URI="https://github.com/pre-commit/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/editdistance-s[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
