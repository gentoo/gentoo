# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

TAG=RELEASE_${PV}
MY_P=XlsxWriter-${TAG}
DESCRIPTION="Python module for creating Excel XLSX files"
HOMEPAGE="https://github.com/jmcnamara/XlsxWriter"
SRC_URI="
	https://github.com/jmcnamara/XlsxWriter/archive/${TAG}.tar.gz
		-> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest
