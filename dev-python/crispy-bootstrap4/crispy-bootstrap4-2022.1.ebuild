# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Bootstrap4 template pack for django-crispy-forms"
HOMEPAGE="
	https://pypi.org/project/crispy-bootstrap4/
"
SRC_URI="https://github.com/django-crispy-forms/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/django-crispy-forms[${PYTHON_USEDEP}]"
BDEPEND="test? (
	dev-python/pytest-django[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest

PATCHES=( "${FILESDIR}"/${P}-test.patch )
