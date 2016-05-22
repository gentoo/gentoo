# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3,3_4,3_5} pypy )
inherit distutils-r1

DESCRIPTION="A Python API for libmagic, the library behind the Unix file command"
HOMEPAGE="https://pypi.python.org/pypi/filemagic https://github.com/aliles/filemagic"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		sys-apps/file"
RDEPEND=""
