# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/_}
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="sip extension module for PyQt5"
HOMEPAGE="https://www.riverbankcomputing.com/software/sip/ https://pypi.org/project/PyQt5-sip/"

if [[ ${PV} == *_pre* ]]; then
	MY_P=${PYPI_PN}-${PV/_pre/.dev}
	SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
else
	inherit pypi
fi

LICENSE="|| ( GPL-2 GPL-3 SIP )"
SLOT="0/$(ver_cut 1)"
KEYWORDS="amd64 arm arm64 ~loong ~ppc ppc64 ~riscv x86"
