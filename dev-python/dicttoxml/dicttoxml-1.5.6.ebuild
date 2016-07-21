# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python{2_7,3_3,3_4})

inherit distutils-r1

DESCRIPTION="Converts a Python dictionary or other native data type into a valid XML string"
HOMEPAGE="https://github.com/quandyfactory/dicttoxml"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
