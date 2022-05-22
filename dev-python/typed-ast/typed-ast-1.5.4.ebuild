# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Python typed-ast backported"
HOMEPAGE="
	https://github.com/python/typed_ast/
	https://pypi.org/project/typed-ast/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN/-/_}/${P/-/_}.tar.gz"
S="${WORKDIR}/${P/-/_}"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

distutils_enable_tests pytest

python_test() {
	cd "${BUILD_DIR}" || die
	epytest
}
