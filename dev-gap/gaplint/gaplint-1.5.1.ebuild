# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Linter for GAP"
HOMEPAGE="
	https://github.com/james-d-mitchell/gaplint
	https://pypi.org/project/gaplint
"

# Use the github tarball because it includes the tests.
SRC_URI="https://github.com/james-d-mitchell/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_prepare() {
	default
	# The gaplint argument parser has workarounds for "pytest" and
	# "py.test", but we run pytest with "python -m pytest":
	#
	#   https://github.com/james-d-mitchell/gaplint/issues/57
	#
	sed -e 's/py.test/__main__.py/' -i gaplint.py \
		|| die "failed to further hack the existing pytest hack"
}
