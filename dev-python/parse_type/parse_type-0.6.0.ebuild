# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Extension to the parse module"
HOMEPAGE="https://pypi.org/project/parse-type/"
SRC_URI="https://github.com/jenisys/parse_type/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/parse[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-setupwarn.patch
)

DOCS=( CHANGES.txt README.rst )

python_prepare_all() {
	distutils-r1_python_prepare_all

	# disable unnecessary html test report and its pytest-html dependency
	sed -i '/^addopts/,/report.xml$/d' pytest.ini || die
}
