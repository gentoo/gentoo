# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Seamless Polymorphic Inheritance for Django Models"
HOMEPAGE="
	https://github.com/jazzband/django-polymorphic/
	https://pypi.org/project/django-polymorphic/
"
SRC_URI="
	https://github.com/jazzband/django-polymorphic/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/django-3.2[$PYTHON_USEDEP]
"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		${RDEPEND}
		dev-python/dj-database-url[${PYTHON_USEDEP}]
		dev-python/pytest-django[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	# ecb85b3539c71e376eb0a111e98b5b374d5c9532
	"${FILESDIR}/${P}-test.patch"
)
