# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )

inherit distutils-r1

MY_PN="${PN}-python"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A portable, lightweight MessagePack serializer and deserializer"
HOMEPAGE="https://github.com/vsergeev/u-msgpack-python https://pypi.org/project/u-msgpack-python/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

RESTRICT="!test? ( test )"

S=${WORKDIR}/${MY_P}

PATCHES=("${FILESDIR}"/${P}-little-endian.patch)

python_test() {
	py.test -v || die "Tests fail with ${EPYTHON}"
}
