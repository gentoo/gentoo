# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A robust email syntax and deliverability validation library"
HOMEPAGE="https://github.com/JoshData/python-email-validator"
SRC_URI="https://github.com/JoshData/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"

LICENSE="CC0-1.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="
	>=dev-python/idna-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/dnspython-1.15.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	# deliverability tests fail within network-sandbox
	sed -e 's:test_deliverability_:_&:' \
		-i tests/test_main.py || die

	distutils-r1_python_prepare_all
}
