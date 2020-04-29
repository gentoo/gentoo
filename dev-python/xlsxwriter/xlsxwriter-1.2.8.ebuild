# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

MY_PN="XlsxWriter"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python module for creating Excel XLSX files"
HOMEPAGE="https://github.com/jmcnamara/XlsxWriter"
SRC_URI="https://github.com/jmcnamara/XlsxWriter/archive/RELEASE_${PV}.tar.gz -> ${P}-tests.tar.gz"
S="${WORKDIR}/${MY_PN}-RELEASE_${PV}"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest
