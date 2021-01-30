# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 git-r3

DESCRIPTION="metadata.xml generator for ebuilds"
HOMEPAGE="https://cgit.gentoo.org/proj/metagen.git"
EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/metagen.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE=""
DEPEND="dev-python/lxml[${PYTHON_USEDEP}]
	sys-apps/portage[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_install_all() {
	distutils-r1_python_install_all
	doman docs/metagen.1
}

src_install() {
	distutils-r1_src_install

	# Address expected path warning for /usr/share/doc/metagen-<not-9999>
	mv "${D}"/usr/share/doc/metagen-{*.*.*/*,${PV}/} || die
	rmdir "${D}"/usr/share/doc/metagen-*.*.*/ || die
}

python_test() {
	"${PYTHON}" -c "from metagen import metagenerator; metagenerator.do_tests()" || die
}
