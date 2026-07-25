# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

MY_P="Flask-HTMLmin-${PV}"
DESCRIPTION="Minimize your flask rendered html"
HOMEPAGE="
	https://github.com/hamidfzm/Flask-HTMLmin/
	https://pypi.org/project/Flask-HTMLmin/
"
SRC_URI="
	https://github.com/hamidfzm/Flask-HTMLmin/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="
	app-text/cssmin[${PYTHON_USEDEP}]
	>=app-text/htmlmin-0.1.13[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
