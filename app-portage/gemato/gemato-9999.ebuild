# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python{3_6,3_7,3_8} pypy3 )
PYTHON_REQ_USE='threads(+)'

inherit distutils-r1 git-r3

DESCRIPTION="Stand-alone Manifest generation & verification tool"
HOMEPAGE="https://github.com/mgorny/gemato"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mgorny/gemato.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE="+gpg tools"

RDEPEND="
	gpg? ( app-crypt/gnupg )"

distutils_enable_tests setup.py

python_install_all() {
	distutils-r1_python_install_all

	if use tools; then
		exeinto /usr/share/gemato
		doexe utils/*.{bash,py}
	fi
}
