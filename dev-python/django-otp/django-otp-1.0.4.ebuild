# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Django framework adding two-factor authentication using one-time passwords"
HOMEPAGE="https://github.com/django-otp/django-otp/"
SRC_URI="
	https://github.com/django-otp/django-otp/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/django-2.2[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/qrcode[${PYTHON_USEDEP}]
		${RDEPEND}
	)"

python_test() {
	local -x PYTHONPATH=test:${PYTHONPATH}
	local -x DJANGO_SETTINGS_MODULE=test_project.settings
	django-admin test -v 2 django_otp || die "Tests fail with ${EPYTHON}"
}
