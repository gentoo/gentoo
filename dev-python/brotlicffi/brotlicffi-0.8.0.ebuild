# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} pypy3 )

inherit distutils-r1

# Commit of the Brotli library bundled within brotlipy.
BROTLI_BUNDLED_COMMIT="46c1a881b41bb638c76247558aa04b1591af3aa7"

DESCRIPTION="Python binding to the Brotli library"
HOMEPAGE="https://github.com/python-hyper/brotlipy/ https://pypi.python.org/pypi/brotlipy"
SRC_URI="
	https://github.com/python-hyper/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	test? (
		https://github.com/google/brotli/archive/${BROTLI_BUNDLED_COMMIT}.tar.gz
			-> brotli-${BROTLI_BUNDLED_COMMIT}.tar.gz
	)"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	app-arch/brotli:=
	virtual/python-cffi[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	# remove custom dictionary code that isn't supported by new brotli
	"${FILESDIR}"/brotlicffi-0.8.0-remove-dict.patch
)

src_unpack() {
	default
	if use test; then
		mv "brotli-${BROTLI_BUNDLED_COMMIT}"/tests "${S}"/libbrotli/ || die
	fi
}

src_configure() {
	export USE_SHARED_BROTLI=1
}
