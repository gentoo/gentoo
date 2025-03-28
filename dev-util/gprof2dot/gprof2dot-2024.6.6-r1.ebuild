# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..13} )
PYTHON_REQ_USE='xml(+)'

inherit distutils-r1 pypi

DESCRIPTION="Converts profiling output to dot graphs"
HOMEPAGE="
	https://github.com/jrfonseca/gprof2dot/
	https://pypi.org/project/gprof2dot/
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
