# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7,8} )

inherit distutils-r1

DESCRIPTION="Fixed size round-robin style database"
HOMEPAGE="https://github.com/graphite-project/whisper"
# PyPI tarballs don't contain tests
# https://github.com/graphite-project/whisper/pull/253
SRC_URI="https://github.com/graphite-project/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_test() {
	py.test || die "tests failed with ${EPYTHON}"
}
