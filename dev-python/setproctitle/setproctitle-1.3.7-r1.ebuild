# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The package has a fallback implementation which is a noop but warns
# if the extensions weren't built, so we always build them.
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Allow customization of the process title"
HOMEPAGE="
	https://github.com/dvarrazzo/py-setproctitle/
	https://pypi.org/project/setproctitle/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		# https://github.com/dvarrazzo/py-setproctitle/commit/68125abf821ee6ebfb4a4eb86ffe655a4c072c9e
		"${FILESDIR}/${P}-py315.patch"
	)

	distutils-r1_src_prepare

	# remove the override that makes extension builds non-fatal
	sed -i -e '/cmdclass/d' setup.py || die
}
