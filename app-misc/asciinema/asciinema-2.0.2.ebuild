# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS="rdepend"
inherit distutils-r1

DESCRIPTION="Command line recorder for asciinema.org service"
HOMEPAGE="https://asciinema.org/ https://pypi.org/project/asciinema/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i -e "s|data_files=\[('share/doc/asciinema|&-${PVR}|" setup.py || die
}

python_test() {
	nosetests || die
}
