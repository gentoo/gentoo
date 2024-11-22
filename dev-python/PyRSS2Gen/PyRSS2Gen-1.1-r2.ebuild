# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=PyRSS2Gen-${PV}
DESCRIPTION="RSS feed generator written in Python"
HOMEPAGE="
	http://www.dalkescientific.com/Python/PyRSS2Gen.html
	https://pypi.org/project/PyRSS2Gen/
"
SRC_URI="http://www.dalkescientific.com/Python/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
