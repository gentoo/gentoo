# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="metadata.xml generator for ebuilds"
HOMEPAGE="https://cgit.gentoo.org/proj/metagen.git"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 hppa ppc x86 ~amd64-linux ~x86-linux"

IUSE=""
DEPEND="dev-python/lxml[${PYTHON_USEDEP}]
	sys-apps/portage[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_install_all() {
	distutils-r1_python_install_all
	doman docs/metagen.1
}

python_test() {
	"${PYTHON}" -c "from metagen import metagenerator; metagenerator.do_tests()" || die
}
