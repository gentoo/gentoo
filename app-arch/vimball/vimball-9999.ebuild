# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/radhermit/vimball.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
fi

DESCRIPTION="a command-line vimball archive extractor"
HOMEPAGE="https://github.com/radhermit/vimball"

LICENSE="MIT"
SLOT="0"

distutils_enable_tests pytest
