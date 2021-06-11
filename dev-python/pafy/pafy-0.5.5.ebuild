# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/mps-youtube/pafy.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Python library to retrieve YouTube content and metadata"
HOMEPAGE="https://pythonhosted.org/pafy/ https://pypi.org/project/pafy/"

LICENSE="LGPL-3"
SLOT="0"

RDEPEND="net-misc/youtube-dl[${PYTHON_USEDEP}]"
