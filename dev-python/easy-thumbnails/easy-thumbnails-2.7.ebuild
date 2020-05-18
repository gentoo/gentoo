# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Easy thumbnails for Django"
HOMEPAGE="https://pypi.org/project/easy-thumbnails/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/django-1.11[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		${RDEPEND}
		dev-python/testfixtures[${PYTHON_USEDEP}]
	)
"

python_test() {
	local -x DJANGO_SETTINGS_MODULE=easy_thumbnails.tests.settings
	local -x PYTHONPATH=.
	django-admin test -v 2 || die "Tests failed with ${EPYTHON}"
}
