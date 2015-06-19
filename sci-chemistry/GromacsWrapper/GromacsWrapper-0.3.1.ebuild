# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/GromacsWrapper/GromacsWrapper-0.3.1.ebuild,v 1.3 2015/04/08 18:22:13 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

if [[ $PV = *9999* ]]; then
	scm_eclass=git-2
	EGIT_REPO_URI="
		git://github.com/orbeckst/${PN}.git
		https://github.com/orbeckst/${PN}.git"
	EGIT_BRANCH="develop"
	SRC_URI=""
	KEYWORDS=""
else
	scm_eclass=vcs-snapshot
	SRC_URI="https://github.com/orbeckst/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit eutils distutils-r1 ${scm_eclass}

DESCRIPTION="Python framework for Gromacs"
HOMEPAGE="http://orbeckst.github.com/GromacsWrapper/"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
IUSE=""

DEPEND="
		>=dev-python/matplotlib-0.91.3[${PYTHON_USEDEP}]
		>=dev-python/RecSQL-0.3[${PYTHON_USEDEP}]
		>=sci-libs/scipy-0.9[${PYTHON_USEDEP}]
		"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/0001-Drop-chmod-hack.patch"
)
