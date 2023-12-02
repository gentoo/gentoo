# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Expand system variables Unix style"
HOMEPAGE="
	https://github.com/sayanarijit/expandvars/
	https://pypi.org/project/expandvars/
"
SRC_URI="
	https://github.com/sayanarijit/expandvars/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# requires toml, useless
	tests/test_expandvars.py::test_version
)

src_prepare() {
	# sigh
	cat >> pyproject.toml <<-EOF || die
		[build-system]
		requires = ["poetry-core"]
		build-backend = "poetry.core.masonry.api"
	EOF

	distutils-r1_src_prepare
}
