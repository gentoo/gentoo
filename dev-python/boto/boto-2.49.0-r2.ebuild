# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1

DESCRIPTION="Amazon Web Services API"
HOMEPAGE="https://github.com/boto/boto https://pypi.org/project/boto/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test"

BDEPEND="
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

RESTRICT="!test? ( test )"

# requires Amazon Web Services keys to pass some tests
RESTRICT+=" test"

PATCHES=(
	# taken from https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=909545
	"${FILESDIR}/boto-try-to-add-SNI-support-v2.patch"
)

python_test() {
	"${PYTHON}" tests/test.py -v || die "Tests fail with ${EPYTHON}"
}
