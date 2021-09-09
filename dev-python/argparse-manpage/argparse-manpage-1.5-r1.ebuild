# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Automatically build man-pages for your Python project"
HOMEPAGE="https://github.com/praiskup/argparse-manpage https://pypi.org/project/argparse-manpage/"
SRC_URI="https://github.com/praiskup/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

PATCHES=(
	"${FILESDIR}/${P}-remove-six-dep.patch"
)

distutils_enable_tests pytest
