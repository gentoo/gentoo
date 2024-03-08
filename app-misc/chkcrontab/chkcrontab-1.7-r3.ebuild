# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

DESCRIPTION="A tool to detect crontab errors"
HOMEPAGE="https://github.com/lyda/chkcrontab"
SRC_URI="https://github.com/lyda/chkcrontab/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${PN}-man.patch"
	"${FILESDIR}/${PN}-py312.patch"
)

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i 's/assertEquals/assertEqual/g' tests/test_check.py || die
}

python_install_all() {
	doman doc/${PN}.1
	distutils-r1_python_install_all
}
