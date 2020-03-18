# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 multilib prefix git-r3
EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/javatoolkit.git"
SRC_URI=""
KEYWORDS=""

DESCRIPTION="Collection of Gentoo-specific tools for Java"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Java"

LICENSE="GPL-2"
SLOT="0"

python_prepare_all() {
	hprefixify src/py/buildparser src/py/findclass setup.py

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install \
		--install-scripts="${EPREFIX}"/usr/$(get_libdir)/${PN}/bin
}
