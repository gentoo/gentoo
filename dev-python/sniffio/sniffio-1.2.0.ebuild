# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Sniff out which async library your code is running under"
HOMEPAGE="
	https://github.com/python-trio/sniffio/
	https://pypi.org/project/sniffio/"
SRC_URI="
	https://github.com/python-trio/sniffio/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# curio is not packaged
		sniffio/_tests/test_sniffio.py::test_curio
	)

	epytest ${deselect[@]/#/--deselect }
}
