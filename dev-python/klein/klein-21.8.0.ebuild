# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="micro-framework for developing production-ready web services with Python"
HOMEPAGE="https://pypi.org/project/klein/ https://github.com/twisted/klein/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/hyperlink[${PYTHON_USEDEP}]
	dev-python/incremental[${PYTHON_USEDEP}]
	dev-python/tubes[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.6[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/treq[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-test_resource.patch
)

distutils_enable_tests pytest

python_prepare_all() {
	# known test fail: https://github.com/twisted/klein/issues/339
#	sed -e 's/big world/big+world/' \
#		-e 's/4321)]/4321.0)]/' \
#		-e 's/not a number/not+a+number/' \
#		-i src/klein/test/test_form.py  || die

	distutils-r1_python_prepare_all
}
