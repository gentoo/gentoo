# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

# Commit of the Brotli library bundled within brotlipy.
BROTLI_BUNDLED_COMMIT="46c1a881b41bb638c76247558aa04b1591af3aa7"

DESCRIPTION="Python binding to the Brotli library"
HOMEPAGE="https://github.com/python-hyper/brotlipy/ https://pypi.python.org/pypi/brotlipy"
SRC_URI="
	https://github.com/python-hyper/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/google/brotli/archive/${BROTLI_BUNDLED_COMMIT}.tar.gz -> brotli-${BROTLI_BUNDLED_COMMIT}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# module name collision with app-arch/brotli
RDEPEND="
	virtual/python-cffi[${PYTHON_USEDEP}]
	!app-arch/brotli[python]"
DEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/brotlipy-0.7.0-test-deadline.patch
)

src_prepare() {
	# Inject the brotli lib.
	rm -r "${WORKDIR}/${P}/libbrotli" || die "Could not remove the bundled brotli lib folder."
	cp -r "${WORKDIR}/brotli-${BROTLI_BUNDLED_COMMIT}/" "${WORKDIR}/${P}/libbrotli" || die "Could not inject the brotli lib."

	# Tests fail if we have this folder preserved within the lib.
	rm -r "${WORKDIR}/${P}/libbrotli/python" || die "Could not remove 'python' subfolder."

	distutils-r1_src_prepare
}
