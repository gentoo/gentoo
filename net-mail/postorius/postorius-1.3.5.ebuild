# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="A web user interface for GNU Mailman 3"
HOMEPAGE="https://www.list.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
	dev-python/readme_renderer[${PYTHON_USEDEP}]
	net-mail/django-mailman3[${PYTHON_USEDEP}]
	net-mail/mailmanclient[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/vcrpy[${PYTHON_USEDEP}]
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/pytest-django[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		net-mail/mailman[${PYTHON_USEDEP}]
	)
"

DOCS=( README.rst )

distutils_enable_tests pytest

src_prepare() {
	sed -e 's/test_list_info/_&/' -i src/postorius/tests/mailman_api_tests/test_list_summary.py || die
	distutils-r1_src_prepare
}

python_test() {
	local -x PYTHONPATH="${S}/src"
	cd example_project || die
	epytest ../src
}
