# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Library to parse and apply unified diffs, fork of dev-python/patch"
HOMEPAGE="https://github.com/conan-io/python-patch-ng https://pypi.org/project/patch-ng/"
SRC_URI="https://github.com/conan-io/python-patch-ng/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/python-${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86 ~amd64-linux ~x86-linux"

distutils_enable_tests unittest

python_test() {
	"${EPYTHON}" -m unittest -v tests/run_tests.py || die "Tests failed under ${EPYTHON}"
}
