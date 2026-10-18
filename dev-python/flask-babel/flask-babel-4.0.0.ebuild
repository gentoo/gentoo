# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="i18n and l10n support for Flask based on Babel and pytz"
HOMEPAGE="
	https://python-babel.github.io/flask-babel/
	https://github.com/python-babel/flask-babel/
	https://pypi.org/project/flask-babel/
"
SRC_URI="
	https://github.com/python-babel/flask-babel/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	>=dev-python/babel-2.12[${PYTHON_USEDEP}]
	>=dev-python/flask-2.0[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.1[${PYTHON_USEDEP}]
	>=dev-python/pytz-2022.7[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/pallets-sphinx-themes
EPYTEST_PLUGINS=( pytest-mock )
distutils_enable_tests pytest
