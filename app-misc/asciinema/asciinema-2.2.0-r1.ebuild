# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Command line recorder for asciinema.org service"
HOMEPAGE="https://asciinema.org/ https://pypi.org/project/asciinema/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~riscv ~x86"

PATCHES=(
	"${FILESDIR}/asciinema-2.2.0-setup.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i -e "s|share/doc/asciinema|&-${PVR}|" setup.cfg || die
}
