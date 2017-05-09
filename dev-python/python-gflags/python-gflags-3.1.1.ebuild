# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Google's Python argument parsing library"
HOMEPAGE="https://github.com/google/python-gflags"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${P}-script-install.patch
)

python_test() {
	# note: each test needs to be run separately, otherwise they fail
	"${PYTHON}" -m gflags._helpers_test -v || die
	"${PYTHON}" -m gflags.flags_formatting_test -v || die
	"${PYTHON}" -m gflags.flags_unicode_literals_test -v || die
}
