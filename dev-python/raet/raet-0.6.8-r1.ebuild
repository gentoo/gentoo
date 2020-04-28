# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=(python3_{7,8})
inherit distutils-r1

DESCRIPTION="Reliable Asynchronous Event Transport Protocol"
HOMEPAGE="https://github.com/RaetProtocol/raet"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/six-1.6.1[${PYTHON_USEDEP}]
	>=dev-python/libnacl-1.4.3[${PYTHON_USEDEP}]
	>=dev-python/ioflo-2.0[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	test? (
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
	)"

PATCHES=(
	# This is from https://github.com/RaetProtocol/raet/pull/14/
	#${FILESDIR}/raet-0.6.8-msgpack-1.0.patch
)

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i -e "/setuptools_git/d" setup.py || die
}

python_test() {
	pushd "${BUILD_DIR}"/lib || die
	${EPYTHON} ${PN}/test/__init__.py || die "tests failed for ${EPYTHON}"
	popd || die
}
