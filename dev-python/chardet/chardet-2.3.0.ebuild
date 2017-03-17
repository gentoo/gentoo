# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Universal encoding detector"
HOMEPAGE="https://github.com/chardet/chardet https://pypi.python.org/pypi/chardet"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x64-cygwin ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
