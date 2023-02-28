# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="DRY Django forms"
HOMEPAGE="https://github.com/django-crispy-forms/django-crispy-forms"
SRC_URI="https://github.com/django-crispy-forms/${PN}/archive/${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test" #Missing crispy_bootstrap3

RDEPEND="dev-python/django[${PYTHON_USEDEP}]"
BDEPEND="test? (
	dev-python/pytest-django[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest
