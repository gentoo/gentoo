# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="A Python interface to libarchive"
HOMEPAGE="https://github.com/Changaco/python-libarchive-c/ https://pypi.org/project/libarchive-c/"
SRC_URI="
	https://github.com/Changaco/python-libarchive-c/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}"/python-${P}

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~ppc64 x86"

RDEPEND="app-arch/libarchive"
BDEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
