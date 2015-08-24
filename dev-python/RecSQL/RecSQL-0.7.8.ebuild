# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

if [[ $PV = *9999* ]]; then
	scm_eclass=git-2
	EGIT_REPO_URI="
		git://github.com/orbeckst/${PN}.git
		https://github.com/orbeckst/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
else
	scm_eclass=vcs-snapshot
	SRC_URI="https://github.com/orbeckst/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit eutils distutils-r1 ${scm_eclass}

DESCRIPTION="Simple SQL analysis of python records"
HOMEPAGE="https://orbeckst.github.com/RecSQL/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
