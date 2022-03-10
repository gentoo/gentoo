# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Style preserving TOML library"
HOMEPAGE="https://github.com/sdispater/tomlkit"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="test? ( dev-python/pyyaml[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

src_configure() {
	# use setup.py to avoid circular dep with poetry-core
	cat > pyproject.toml <<-EOF || die
		[build-system]
		requires = ["setuptools", "wheel"]
		build-backend = "setuptools.build_meta"
	EOF
}
