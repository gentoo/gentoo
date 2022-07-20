# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="sip module support for PyQt6"
HOMEPAGE="https://www.riverbankcomputing.com/software/sip/"
SRC_URI="mirror://pypi/${P::1}/${PN}/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 SIP )"
SLOT="0"
KEYWORDS="~amd64"
