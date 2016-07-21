# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="pyRadKDE"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A wheel type command interface for KDE, heavily inspired by Kommando"
HOMEPAGE="https://bitbucket.org/ArneBab/pyrad https://pypi.python.org/pypi/pyRadKDE"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}/${MY_P}

RDEPEND="kde-base/pykde4:4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
