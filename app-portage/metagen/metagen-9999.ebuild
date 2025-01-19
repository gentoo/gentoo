# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 git-r3

DESCRIPTION="metadata.xml generator for ebuilds"
HOMEPAGE="https://cgit.gentoo.org/proj/metagen.git"
EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/metagen.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

DEPEND="dev-python/lxml[${PYTHON_USEDEP}]
	sys-apps/portage[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	doman docs/metagen.1

	# Address expected path warning for /usr/share/doc/metagen-<not-9999>
	mv "${ED}"/usr/share/doc/metagen-{*.*.*/*,${PV}/} || die
	rmdir "${ED}"/usr/share/doc/metagen-*.*.*/ || die
}
