# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/pkgcore/pkgcore.git
		https://github.com/pkgcore/pkgcore.git"
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
	inherit pypi
fi

DESCRIPTION="a framework for package management"
HOMEPAGE="https://github.com/pkgcore/pkgcore"

LICENSE="BSD MIT"
SLOT="0"

if [[ ${PV} == *9999 ]]; then
	RDEPEND="~dev-python/snakeoil-9999[${PYTHON_USEDEP}]"
else
	RDEPEND=">=dev-python/snakeoil-0.11.0[${PYTHON_USEDEP}]"
fi

RDEPEND+="
	>=app-shells/bash-5.3[readline]
	dev-python/lxml[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	>=dev-python/flit-core-3.8[${PYTHON_USEDEP}]
	test? (
		dev-vcs/git
	)
"

distutils_enable_tests pytest

python_install_all() {
	local DOCS=( NEWS.rst )
	[[ ${PV} == *9999 ]] || doman build/sphinx/man/*
	distutils-r1_python_install_all
}
