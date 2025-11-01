# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN/-/.}
PYPI_VERIFY_REPO=https://github.com/Rogdham/backports.zstd
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Backport of PEP-784: adding Zstandard to the standard library"
HOMEPAGE="
	https://github.com/Rogdham/backports.zstd/
	https://pypi.org/project/backports.zstd/
"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"

DEPEND="
	app-arch/zstd:=
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests unittest

src_prepare() {
	local PATCHES=(
		# https://github.com/Rogdham/backports.zstd/pull/54
		"${FILESDIR}/${P}-py313.patch"
	)

	distutils-r1_src_prepare

	# remove -flto and other forced cflags
	sed -i -e 's:kwargs\["extra.*:pass:' setup.py || die

	DISTUTILS_ARGS=(
		--system-zstd
	)

	# remove namespace file
	rm src/python/backports/__init__.py || die
}

python_test() {
	eunittest tests
}
