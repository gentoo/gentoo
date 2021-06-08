# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} pypy3 )

inherit distutils-r1

DESCRIPTION="Optional static typing for Python"
HOMEPAGE="http://www.mypy-lang.org/"
SRC_URI="https://github.com/python/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

if [[ "${PV}" =~ [9]{4,} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/python/${PN}"
	EGIT_COMMIT="master"
else
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~x64-macos"
fi

LICENSE="MIT"
SLOT="0"

IUSE="test"
RESTRICT="!test? ( test )"

distutils_enable_tests unittest
distutils_enable_sphinx docs \
	dev-python/sphinx \
	dev-python/sphinx_rtd_theme

python_test() {
	"${PYTHON}" -m unittest discover tests -v || die "tests fail with ${EPYTHON}"
}
