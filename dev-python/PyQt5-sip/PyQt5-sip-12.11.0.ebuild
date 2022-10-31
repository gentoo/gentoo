# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="sip extension module for PyQt5"
HOMEPAGE="https://www.riverbankcomputing.com/software/sip/ https://pypi.org/project/PyQt5-sip/"

MY_P=${PN/-/_}-${PV/_pre/.dev}
if [[ ${PV} == *_pre* ]]; then
	SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
fi
S="${WORKDIR}/${MY_P}"

LICENSE="|| ( GPL-2 GPL-3 SIP )"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
