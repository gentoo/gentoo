# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A tool to detect crontab errors"
HOMEPAGE="https://github.com/lyda/chkcrontab"
SRC_URI="https://github.com/lyda/chkcrontab/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

python_test() {
	esetup.py test || die
}

python_install_all() {
	doman doc/${PN}.1
	distutils-r1_python_install_all
}
