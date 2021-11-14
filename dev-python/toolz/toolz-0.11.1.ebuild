# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="List processing tools and functional utilities"
HOMEPAGE="https://pypi.org/project/toolz/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	dev-python/versioneer[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-py310.patch
)
