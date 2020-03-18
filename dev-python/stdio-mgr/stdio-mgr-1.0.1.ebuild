# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Context manager for mocking/wrapping stdin/stdout/stderr"
HOMEPAGE="
	https://github.com/bskinn/stdio-mgr
	https://pypi.org/project/stdio-mgr
"
SRC_URI="https://github.com/bskinn/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86 "
SLOT="0"

distutils_enable_tests pytest

python_test() {
	pytest -vv tests || "Tests fail with ${EPYTHON}"
}
