# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

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

DESCRIPTION="Numerical first aid kit (with numpy/scipy)"
HOMEPAGE="https://numkit.readthedocs.io"

LICENSE="BSD"
SLOT="0"
IUSE=""

BDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.9[${PYTHON_USEDEP}]
	>=sci-libs/scipy-1.0[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
