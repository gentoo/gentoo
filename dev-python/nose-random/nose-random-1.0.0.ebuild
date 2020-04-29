# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Nose plugin to facilitate randomized unit testing"
HOMEPAGE="https://github.com/fzumstein/nose-random"
SRC_URI="https://github.com/fzumstein/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/nose[${PYTHON_USEDEP}]"

# no tests
