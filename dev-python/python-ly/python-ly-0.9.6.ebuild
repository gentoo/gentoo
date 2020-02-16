# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Tool and library for manipulating LilyPond files"
HOMEPAGE="https://github.com/wbsoft/python-ly https://pypi.org/project/python-ly/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# no tests in pypi tarball and broken apparently:
# https://github.com/wbsoft/python-ly/issues/70
