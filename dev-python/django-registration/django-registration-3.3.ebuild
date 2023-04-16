# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
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
KEYWORDS="~amd64"
RESTRICT="test" # Tests are not working here

RDEPEND="dev-python/django[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
