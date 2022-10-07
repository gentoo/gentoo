# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..11} pypy3 )
PYTHON_REQ_USE='threads(+)'

inherit distutils-r1 git-r3

DESCRIPTION="Stand-alone Manifest generation & verification tool"
HOMEPAGE="https://github.com/projg2/gemato"
SRC_URI=""
EGIT_REPO_URI="https://github.com/projg2/gemato.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE="+gpg pretty-log tools"

RDEPEND="
	gpg? (
		>=app-crypt/gnupg-2.2.20-r1
		dev-python/requests[${PYTHON_USEDEP}]
	)
	pretty-log? (
		dev-python/rich[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		>=app-crypt/gnupg-2.2.20-r1
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all

	if use tools; then
		exeinto /usr/share/gemato
		doexe utils/*.{bash,py}
	fi
}
