# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9,10} )

inherit distutils-r1

DESCRIPTION="python interface to Clamd (Clamav daemon)"
HOMEPAGE="https://xael.org/pages/pyclamd-en.html"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

# Tests need clamd running and we cannot rely on that being
# true during build
RESTRICT="test"
