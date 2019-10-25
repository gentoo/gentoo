# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )

inherit distutils-r1

DESCRIPTION="Library to parse and apply unified diffs, fork of dev-python/patch"
HOMEPAGE="https://github.com/conan-io/python-patch-ng"
SRC_URI="https://github.com/conan-io/python-patch-ng/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

BDEPEND="test? ( dev-python/coverage[${PYTHON_USEDEP}] )"

S="${WORKDIR}/python-${P}"

python_test() {
	coverage run tests/run_tests.py || die "tests failed with ${EPYTHON}"
}
