# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="Private sip module for PyQt5"
HOMEPAGE="https://www.riverbankcomputing.com/software/sip/intro"

MY_PN=sip
MY_P=${MY_PN}-${PV/_pre/.dev}
if [[ ${PV} == *_pre* ]]; then
	SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN//-/_}-${PV}.tar.gz"
fi
S="${WORKDIR}/${PN//-/_}-${PV}"

# Sub-slot based on SIP_ABI_MAJOR_VERSION from sip.h
SLOT="0/12"
LICENSE="|| ( GPL-2 GPL-3 SIP )"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
