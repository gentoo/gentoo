# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

# Commit of the Brotli library bundled within brotlipy.
BROTLI_BUNDLED_COMMIT="46c1a881b41bb638c76247558aa04b1591af3aa7"

DESCRIPTION="Python binding to the Brotli library"
HOMEPAGE="
	https://github.com/python-hyper/brotlicffi/
	https://pypi.org/project/brotlicffi/"
SRC_URI="
	https://github.com/python-hyper/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	test? (
		https://github.com/google/brotli/archive/${BROTLI_BUNDLED_COMMIT}.tar.gz
			-> brotli-${BROTLI_BUNDLED_COMMIT}.tar.gz
	)"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	app-arch/brotli:=
	virtual/python-cffi[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_unpack() {
	default
	if use test; then
		mv "brotli-${BROTLI_BUNDLED_COMMIT}"/tests "${S}"/libbrotli/ || die
	fi
}

src_configure() {
	export USE_SHARED_BROTLI=1
}

python_test() {
	local deselect=(
		# incompatible with USE_SHARED_BROTLI=1
		test/test_compatibility.py::test_brotli_version
	)

	pytest -vv ${deselect[@]/#/--deselect } ||
		die "Tests failed with ${EPYTHON}"
}
