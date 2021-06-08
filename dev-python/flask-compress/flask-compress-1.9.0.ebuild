# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

MY_PN="Flask-Compress"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Compress responses in your Flask app with gzip"
HOMEPAGE="https://pypi.org/project/Flask-Compress/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	app-arch/brotli[python,${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
