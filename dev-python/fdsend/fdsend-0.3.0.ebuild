# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 python3_{6,7,8,9,10,11} pypy3 )

inherit distutils-r1

DESCRIPTION="flexible file descriptor passing"
HOMEPAGE="https://github.com/fknittel/python-fdsend/"
SRC_URI="https://github.com/fknittel/python-fdsend/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
DEPEND+=" test? ( dev-python/unittest-or-fail )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}/python-${P}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.0-2to3.patch
)

distutils_enable_tests unittest

python_prepare_all() {
	2to3 . || die

	distutils-r1_python_prepare_all
}
