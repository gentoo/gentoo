# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/parse-type/parse-type-0.3.4.ebuild,v 1.2 2014/11/27 14:43:48 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="Simplifies to build parse types based on the parse module"
HOMEPAGE="https://github.com/jenisys/parse_type"

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=dev-python/parse-1.6[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' 'python2*' 'python3_3')
"

python_test() {
	py.test tests || "Tests failed under ${EPYTHON}"
}
