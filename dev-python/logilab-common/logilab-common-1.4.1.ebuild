# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Useful miscellaneous modules used by Logilab projects"
HOMEPAGE="https://www.logilab.org/project/logilab-common https://pypi.org/project/logilab-common/"
SRC_URI="ftp://ftp.logilab.org/pub/common/${P}.tar.gz mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test"

RDEPEND=">=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		$(python_gen_cond_dep 'dev-python/egenix-mx-base[${PYTHON_USEDEP}]' python2_7)
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

python_test() {
	# https://www.logilab.org/ticket/149345
	# Prevent timezone related failure.
	export TZ=UTC

	${EPYTHON} bin/logilab-pytest || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	# this package is commonly used by all logilab.* in ::gentoo,
	# so let's just keep the namespace here
	python_moduleinto logilab
	python_domodule logilab/__init__.py
}

python_install_all() {
	distutils-r1_python_install_all

	doman doc/logilab-pytest.1
	find "${D}" -name '*.pth' -delete || die
}
