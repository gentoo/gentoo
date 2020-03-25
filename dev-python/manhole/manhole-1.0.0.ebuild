# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MYPN="python-${PN}"

DESCRIPTION="Debugging manhole for python application"
HOMEPAGE="
	https://github.com/ionelmc/python-manhole
	https://pypi.org/project/python-manhole
"
SRC_URI="https://github.com/ionelmc/${MYPN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="
	${RDEPEND}
	test? (
		dev-python/eventlet[${PYTHON_USEDEP}]
		dev-python/gevent[${PYTHON_USEDEP}]
		dev-python/process-tests[${PYTHON_USEDEP}]
		dev-python/pytest-travis-fold[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		www-servers/uwsgi[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MYPN}-${PV}"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
				dev-python/sphinx-py3doc-enhanced-theme \
				dev-python/sphinxcontrib-napoleon
