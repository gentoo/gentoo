# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
fi

DESCRIPTION="Python client for rqlite"
EGIT_REPO_URI="https://github.com/rqlite/pyrqlite.git"
HOMEPAGE="https://github.com/rqlite/pyrqlite"
SRC_URI="${EGIT_REPO_URI%.git}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest

src_prepare() {
	sed -e "s:^__version__ = .*:__version__ = '${PV}':" -i src/${PN}/constants.py || die
	distutils-r1_src_prepare
}
