# Copyright 2018-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="A formatter for Python files"
HOMEPAGE="https://github.com/google/yapf"
SRC_URI="https://github.com/google/yapf/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-python/toml[${PYTHON_USEDEP}] )"

python_test() {
	"${EPYTHON}" -m unittest discover -v -p '*_test.py' ||
		die "Tests failed with ${EPYTHON}"
}
