# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="user-registration application for Django"
HOMEPAGE="
	https://pypi.org/project/django-registration/
	https://github.com/ubernostrum/django-registration/
"
SRC_URI="
	https://github.com/ubernostrum/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/confusable-homoglyphs-3.0[${PYTHON_USEDEP}]
	>=dev-python/django-4.2[${PYTHON_USEDEP}]
	elibc_musl? ( dev-python/tzdata )
"

python_test() {
	local -x DJANGO_SETTINGS_MODULE=tests.settings
	PYTHONPATH=. "${EPYTHON}" runtests.py || die "Tests failed with ${EPYTHON}"
}
