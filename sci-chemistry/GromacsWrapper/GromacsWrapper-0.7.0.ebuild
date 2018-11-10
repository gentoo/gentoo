# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

if [[ $PV = *9999* ]]; then
	scm_eclass=git-r3
	EGIT_REPO_URI="https://github.com/Becksteinlab/${PN}.git"
	EGIT_BRANCH="develop"
	SRC_URI=""
	KEYWORDS=""
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

DEPEND="
	>=dev-python/matplotlib-0.91.3[${PYTHON_USEDEP}]
	>=sci-libs/scipy-0.9[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
