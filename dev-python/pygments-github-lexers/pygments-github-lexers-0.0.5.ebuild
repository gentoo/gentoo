# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )
inherit distutils-r1

DESCRIPTION="Pygments Github custom lexers"
HOMEPAGE="https://github.com/liluo/pygments-github-lexers"
SRC_URI="https://github.com/liluo/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pygments[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"

# no tests
