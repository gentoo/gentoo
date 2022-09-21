# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Colorization of help messages in Click"
HOMEPAGE="https://github.com/click-contrib/click-help-colors"
SRC_URI="
	https://github.com/click-contrib/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="examples"

RDEPEND="dev-python/click[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
