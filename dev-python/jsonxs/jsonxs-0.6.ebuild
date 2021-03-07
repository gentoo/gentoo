# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Get/set values in JSON and Python datastructures"
HOMEPAGE="https://github.com/fboender/jsonxs"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

python_test() {
	"${EPYTHON}" jsonxs/jsonxs.py -v || die "Tests failed with ${EPYTHON}"
}
