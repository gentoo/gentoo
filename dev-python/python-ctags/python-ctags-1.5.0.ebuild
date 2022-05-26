# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..10} )

inherit distutils-r1

MY_PN="${PN}3"
DESCRIPTION="Exuberant Ctags indexing python bindings"
HOMEPAGE="https://github.com/universal-ctags/python-ctags3"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-util/ctags:="

distutils_enable_tests setup.py
