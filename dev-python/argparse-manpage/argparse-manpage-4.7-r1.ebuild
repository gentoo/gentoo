# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Automatically build man-pages for your Python project"
HOMEPAGE="
	https://github.com/praiskup/argparse-manpage/
	https://pypi.org/project/argparse-manpage/
"
SRC_URI="
	https://github.com/praiskup/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

BDEPEND="
	test? (
		dev-python/pip[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/praiskup/argparse-manpage/commit/05f8260e3e715cc6cf59aeb91adc90e66b0e2b19
	"${FILESDIR}/${P}-py315.patch"
)

src_test() {
	local -x XDG_CONFIG_HOME=${T}
	mkdir "${T}/pip" || die
	cat > "${T}/pip/pip.conf" <<-EOF || die
		[install]
		no-build-isolation = false
	EOF

	local -x COLUMNS=80
	distutils-r1_src_test
}
