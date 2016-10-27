# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 versionator

MY_PV=$(replace_version_separator 2 '.fb' ${PV})

DESCRIPTION="A Python library for building configuration shells"
HOMEPAGE="https://github.com/open-iscsi/configshell-fb"
SRC_URI="https://github.com/open-iscsi/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]
	!dev-python/configshell"

S=${WORKDIR}/${PN}-${MY_PV}
