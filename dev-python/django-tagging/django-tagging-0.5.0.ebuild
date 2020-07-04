# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Generic tagging application for Django"
HOMEPAGE="https://pypi.org/project/django-tagging/
	https://github.com/Fantomas42/django-tagging"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/django-1.0[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
	)"

distutils_enable_sphinx docs

python_test() {
	local -x DJANGO_SETTINGS_MODULE=tagging.tests.settings
	local -x PYTHONPATH=.
	django-admin test -v 2 tagging || die "Tests failed with ${EPYTHON}"
}
