# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7,8,9}} pypy3 )

inherit distutils-r1

DESCRIPTION="Let your Python tests travel through time"
HOMEPAGE="https://github.com/spulec/freezegun"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

RDEPEND="
	>dev-python/python-dateutil-2.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -r \
		-e 's:(python-dateutil)>=2.0:\1:' \
		-e "s:'(python-dateutil)>=[0-9.]+,.+':'\1':" \
		-i setup.py

	distutils-r1_python_prepare_all
}

python_prepare() {
	# optional and only works with python3
	if ! python_is_python3; then
		rm freezegun/_async*.py || die
	fi
}
