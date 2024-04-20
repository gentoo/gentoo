# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Colorization of help messages in Click"
HOMEPAGE="
	https://github.com/click-contrib/click-help-colors/
	https://pypi.org/project/click-help-colors/
"
SRC_URI="
	https://github.com/click-contrib/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv"
IUSE="examples"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/click-contrib/click-help-colors/pull/25
	# https://github.com/click-contrib/click-help-colors/pull/26
	"${FILESDIR}/${P}-no-color.patch"
)

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
