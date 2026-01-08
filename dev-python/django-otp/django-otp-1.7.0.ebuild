# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Django framework adding two-factor authentication using one-time passwords"
HOMEPAGE="
	https://github.com/django-otp/django-otp/
	https://pypi.org/project/django-otp/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/django-4.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/freezegun[${PYTHON_USEDEP}]
		|| (
			dev-python/qrcode[${PYTHON_USEDEP}]
			dev-python/segno[${PYTHON_USEDEP}]
		)
		${RDEPEND}
	)
"

python_test() {
	local -x PYTHONPATH=test:${PYTHONPATH}
	local -x DJANGO_SETTINGS_MODULE=test_project.settings
	"${EPYTHON}" -m django test -v 2 django_otp ||
		die "Tests fail with ${EPYTHON}"
}
