# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/dol-sen/pyDeComp.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~dolsen/releases/${PN}/pyDeComp-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
	S="${WORKDIR}/pyDeComp-${PV}"
fi

DESCRIPTION="A python library of common (de)compression and contents handling"
HOMEPAGE="https://github.com/dol-sen/pyDeComp"

LICENSE="BSD"
SLOT="0"

PATCHES=( "${FILESDIR}/${PV}-no-pixz-index.patch" )
