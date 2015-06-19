# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/unittest2/unittest2-0.5.1-r1.ebuild,v 1.15 2015/04/08 08:04:55 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3} pypy )

inherit distutils-r1

PY3_P=${PN}py3k-${PV}

DESCRIPTION="The new features in unittest for Python 2.7 backported to Python 2.4+"
HOMEPAGE="http://pypi.python.org/pypi/unittest2
	http://pypi.python.org/pypi/unittest2py3k http://code.google.com/p/unittest-ext/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	mirror://pypi/${PN:0:1}/${PN}/${PY3_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_prepare_all() {
	# Disable versioning of unit2 script to avoid collision with versioning performed by distutils_src_install().
	sed -i -e "/'%s = unittest2:main_' % SCRIPT2,/d" setup.py || die

	distutils-r1_python_prepare_all
}

select_source() {
	if [[ ${EPYTHON} == python3* ]]; then
		cd "${WORKDIR}"/${PY3_P} || die
	else
		cd "${S}" || die
	fi
}

python_compile() {
	select_source
	distutils-r1_python_compile
}

src_test() {
	# multiprocessing causes test failure with signals
	local DISTUTILS_NO_PARALLEL_BUILD=1

	distutils-r1_src_test
}

python_test() {
	cd "${BUILD_DIR}" || die
	scripts/unit2 discover -s lib || die "Tests fail with ${EPYTHON}"
}

python_install() {
	select_source
	distutils-r1_python_install
}
