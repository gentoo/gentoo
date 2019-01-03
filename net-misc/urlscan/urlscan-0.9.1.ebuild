# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )

inherit distutils-r1

DESCRIPTION="Permit to launch URLs to webrowser inside Mutt mail client"
HOMEPAGE="https://github.com/firecat53/urlscan"
SRC_URI="https://github.com/firecat53/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/urwid[${PYTHON_USEDEP}]"

python_prepare_all () {

	# This disables the installation of docs in a non-gentoo compliant directory.

	sed -ie 's/les\=\[.*$/les\=\[/' setup.py || die 'sed failed'

	distutils-r1_python_prepare_all
}
