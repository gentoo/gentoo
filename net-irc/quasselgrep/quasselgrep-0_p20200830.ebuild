# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
PYTHON_REQ_USE=( sqlite )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 optfeature

DESCRIPTION="Tool for searching quassel logs from the commandline"
HOMEPAGE="https://github.com/fish-face/quasselgrep"

MY_COMMIT="9b6b0bc1252daa6e574363d87d04eebd981215a5"
SRC_URI="https://github.com/fish-face/quasselgrep/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="dev-python/future[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]"

pkg_postinst() {
	optfeature "access postgres db" dev-python/psycopg:2
}
