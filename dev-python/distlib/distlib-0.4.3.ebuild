# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )

inherit distutils-r1 pypi

DESCRIPTION="Low-level components of distutils2/packaging"
HOMEPAGE="
	https://pypi.org/project/distlib/
	https://github.com/pypa/distlib/
"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

# pypiserver is called as external executable
BDEPEND="
	test? (
		dev-python/pypiserver
	)
"

src_prepare() {
	local PATCHES=(
		# use system pypiserver instead of bundled one
		"${FILESDIR}/distlib-0.3.9-system-pypiserver.patch"
	)

	distutils-r1_src_prepare
}

python_test() {
	local -x SKIP_ONLINE=1
	local -x PYTHONHASHSEED=0

	# disable system-site-packages -- distlib has no deps, and is very
	# fragile to packages actually installed on the system
	sed -i -e '/system-site-packages/s:true:false:' \
		"${BUILD_DIR}/install${EPREFIX}/usr/pyvenv.cfg" || die

	"${EPYTHON}" tests/test_all.py -v -x ||
		die "Tests failed with ${EPYTHON}"
}
