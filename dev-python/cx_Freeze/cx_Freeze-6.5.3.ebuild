# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python{3_7,3_8,3_9} )
inherit distutils-r1

DESCRIPTION="Create standalone executables from Python scripts"
HOMEPAGE="https://cx-freeze.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	# bug #491602
	"${FILESDIR}/${PN}-6.5.3-buildsystem.patch"
)

# bug #765385
RESTRICT="test"
