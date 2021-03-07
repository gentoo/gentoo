# Copyright 2018 Sony Interactive Entertainment Inc.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Tool to create and manage NEWS blurbs for CPython"
HOMEPAGE="https://github.com/python/core-workflow/tree/master/blurb"
SRC_URI="https://files.pythonhosted.org/packages/29/4f/268f9aa095cbcf53253c665fd0f5103f22dccf246fe317ab9c5c481b38f5/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/blurb-setuptools.patch"
)
