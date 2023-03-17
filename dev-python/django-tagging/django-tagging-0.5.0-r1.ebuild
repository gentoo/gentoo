# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1 pypi

DESCRIPTION="Generic tagging application for Django"
HOMEPAGE="https://pypi.org/project/django-tagging/
	https://github.com/Fantomas42/django-tagging"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

# wants smart_text which was removed from django-4.0 and up
RDEPEND=">=dev-python/django-1.0[${PYTHON_USEDEP}]
	<dev-python/django-4[${PYTHON_USEDEP}]"
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
