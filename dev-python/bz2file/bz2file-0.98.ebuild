# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Replacement for bz2.BZ2File with features from newest CPython"
HOMEPAGE="https://pypi.org/project/bz2file/ https://github.com/nvawda/bz2file"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux"
IUSE=""

python_test() {
	"${EPYTHON}" test_bz2file.py -v || die "Tests fail with ${EPYTHON}"
}
