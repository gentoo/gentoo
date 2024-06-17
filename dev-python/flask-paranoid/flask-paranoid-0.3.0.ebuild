# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Simple user session protection extension for Flask"
HOMEPAGE="
	https://github.com/miguelgrinberg/flask-paranoid/
	https://pypi.org/project/Flask-Paranoid/
"
SRC_URI="
	https://github.com/miguelgrinberg/flask-paranoid/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
