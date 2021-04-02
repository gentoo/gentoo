# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )

if [[ ${PV} = *9999* ]]; then
	scm_eclass=git-r3
	EGIT_REPO_URI="https://github.com/Becksteinlab/${PN}.git"
	EGIT_BRANCH="develop"
	SRC_URI=""
else
	scm_eclass=vcs-snapshot
	SRC_URI="https://github.com/Becksteinlab/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit eutils distutils-r1 ${scm_eclass}

DESCRIPTION="Python framework for Gromacs"
HOMEPAGE="https://gromacswrapper.readthedocs.io"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
IUSE=""

BDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	sci-libs/numkit[${PYTHON_USEDEP}]
	test? ( >=dev-python/pandas-0.17[${PYTHON_USEDEP}] )
"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/Becksteinlab/GromacsWrapper/issues/182
	"${FILESDIR}"/${P}-tests-package.patch
)
