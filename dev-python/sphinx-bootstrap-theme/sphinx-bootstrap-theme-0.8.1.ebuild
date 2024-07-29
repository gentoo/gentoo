# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Sphinx theme integrates the Bootstrap CSS / JavaScript framework"
HOMEPAGE="
	https://ryan-roemer.github.io/sphinx-bootstrap-theme/README.html
	https://github.com/ryan-roemer/sphinx-bootstrap-theme/
	https://pypi.org/project/sphinx-bootstrap-theme/
"
SRC_URI="
	https://github.com/ryan-roemer/sphinx-bootstrap-theme/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"

python_test() {
	cd demo || die
	"${EPYTHON}" -m sphinx -d "${BUILD_DIR}"/doctrees \
		-b html source "${BUILD_DIR}"/html || die
}
