# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="metadata.xml generator for ebuilds"
HOMEPAGE="https://cgit.gentoo.org/proj/metagen.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~riscv ~x86 ~amd64-linux ~x86-linux"

IUSE=""
DEPEND="dev-python/lxml[${PYTHON_USEDEP}]
	sys-apps/portage[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_install_all() {
	distutils-r1_python_install_all
	doman docs/metagen.1

	# Bug 814545 and 832069
	if [[ ${PF} != ${P} ]]; then  # to be robust across bumps
		mv "${ED}"/usr/share/doc/${P}/* "${ED}"/usr/share/doc/${PF}/ || die
		rmdir "${ED}"/usr/share/doc/${P}/ || die
	fi
}

python_test() {
	"${PYTHON}" -c "from metagen import metagenerator; metagenerator.do_tests()" || die
}
