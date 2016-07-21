# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python{2_7,3_4,3_5})
inherit distutils-r1

DESCRIPTION="Reliable Asynchronous Event Transport Protocol"
HOMEPAGE="https://github.com/saltstack/raet"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/six-1.6.1[${PYTHON_USEDEP}]
	>=dev-python/libnacl-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/ioflo-1.5[${PYTHON_USEDEP}]
	python_targets_python2_7? ( >=dev-python/enum34-1.0.4[$(python_gen_usedep 'python2*')] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/unittest2[${PYTHON_USEDEP}] )"

python_test() {
	pushd "${BUILD_DIR}"/lib
	${EPYTHON} ${PN}/test/__init__.py || die "tests failed for ${EPYTHON}"
	popd
}
