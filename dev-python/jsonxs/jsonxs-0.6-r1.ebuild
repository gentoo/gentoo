# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Get/set values in JSON and Python datastructures"
HOMEPAGE="
	https://github.com/fboender/jsonxs/
	https://pypi.org/project/jsonxs/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

python_test() {
	"${EPYTHON}" jsonxs/jsonxs.py -v || die "Tests failed with ${EPYTHON}"
}
