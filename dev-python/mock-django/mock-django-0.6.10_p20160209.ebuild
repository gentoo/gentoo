# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

COMMIT="1168d3255e0d67fbf74a9c71feaccbdafef59d21"

DESCRIPTION="Simple library for mocking certain Django behavior"
HOMEPAGE="https://github.com/dcramer/mock-django"
SRC_URI="https://github.com/dcramer/mock-django/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${COMMIT}"
RDEPEND="
	>=dev-python/django-1.11[${PYTHON_USEDEP}]
	dev-python/django-js-asset[${PYTHON_USEDEP}]
"

DEPEND="
	test? (
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests setup.py
