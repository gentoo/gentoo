# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/pkgdev.git"
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
fi

DESCRIPTION="pkgcore-based git QA tool"
HOMEPAGE="https://github.com/pkgcore/pkgdev"

LICENSE="BSD MIT"
SLOT="0"

if [[ ${PV} == *9999 ]]; then
	RDEPEND="
		~dev-python/snakeoil-9999[${PYTHON_USEDEP}]
		~sys-apps/pkgcore-9999[${PYTHON_USEDEP}]"
fi
