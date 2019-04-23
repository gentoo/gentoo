# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=(python2_7 python3_{5,6} pypy)
inherit distutils-r1

DESCRIPTION="Structured Logging for Python"
HOMEPAGE="http://www.structlog.org/en/stable/"
SRC_URI="https://github.com/hynek/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
