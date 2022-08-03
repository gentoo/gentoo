# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Easy thumbnails for Django"
HOMEPAGE="
	https://pypi.org/project/easy-thumbnails/
	https://github.com/SmileyChris/easy-thumbnails/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="svg test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/django-2.2[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	svg? (
		dev-python/reportlab[${PYTHON_USEDEP}]
		dev-python/svglib[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		${RDEPEND}
		dev-python/reportlab[${PYTHON_USEDEP}]
		dev-python/svglib[${PYTHON_USEDEP}]
		dev-python/testfixtures[${PYTHON_USEDEP}]
	)
"

python_test() {
	local -x DJANGO_SETTINGS_MODULE=easy_thumbnails.tests.settings
	local -x PYTHONPATH="${S}"
	django-admin test -v 2 || die "Tests failed with ${EPYTHON}"
}
