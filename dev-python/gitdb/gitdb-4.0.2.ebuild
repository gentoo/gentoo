# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="GitDB is a pure-Python git object database"
HOMEPAGE="
	https://github.com/gitpython-developers/gitdb
	https://pypi.org/project/gitdb/"
SRC_URI="https://github.com/gitpython-developers/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-vcs/git
	>=dev-python/smmap-3.0.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

distutils_enable_sphinx doc/source

# Testsuite appears to require files from a git repo
