# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/pkgdev.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64 ~riscv ~x64-macos"
fi

DESCRIPTION="Collection of tools for Gentoo development"
HOMEPAGE="https://github.com/pkgcore/pkgdev"

LICENSE="BSD MIT"
SLOT="0"

if [[ ${PV} == *9999 ]] ; then
	# https://github.com/pkgcore/pkgdev/blob/main/requirements/dev.txt
	RDEPEND="
		~dev-python/snakeoil-9999[${PYTHON_USEDEP}]
		~dev-util/pkgcheck-9999[${PYTHON_USEDEP}]
		~sys-apps/pkgcore-9999[${PYTHON_USEDEP}]
	"
else
	# https://github.com/pkgcore/pkgdev/blob/main/requirements/install.txt
	RDEPEND="
		>=dev-python/snakeoil-0.9.6[${PYTHON_USEDEP}]
		>=dev-util/pkgcheck-0.10.0[${PYTHON_USEDEP}]
		>=sys-apps/pkgcore-0.12.0[${PYTHON_USEDEP}]
	"
fi

# Uses pytest but we want to use the setup.py runner to get generated modules
BDEPEND+="test? ( dev-python/pytest )"
RDEPEND+="dev-vcs/git"

distutils_enable_sphinx doc
distutils_enable_tests setup.py

python_install_all() {
	# We'll generate man pages ourselves
	# Revisit when a release is made
	# to pregenerate them, making USE=doc
	# for generating the real HTML docs only.
	if use doc ; then
		cd doc || die
		emake man
		doman _build/man/*
	fi

	cd .. || die

	# HTML pages only
	sphinx_compile_all

	distutils-r1_python_install_all
}
