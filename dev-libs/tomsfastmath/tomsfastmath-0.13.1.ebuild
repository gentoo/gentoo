# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Fast public domain large integer arithmetic library"
HOMEPAGE="https://www.libtom.net/TomsFastMath/
	https://github.com/libtom/tomsfastmath"
SRC_URI="https://github.com/libtom/tomsfastmath/releases/download/v${PV}/tfm-${PV}.tar.xz"
LICENSE="Unlicense"

# Current SONAME is 1
# Please bump when the ABI changes upstream
# Helpful site:
# https://abi-laboratory.pro/index.php?view=timeline&l=tomsfastmath
SLOT="0/1"

KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}/${P}-makefile-fix.patch"
)

_emake() {
	# Standard boilerplate
	# Upstream use homebrewed makefiles
	# Best to use same args for all, for consistency,
	# in case behaviour changes (v possible).
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		DESTDIR="${ED}" \
		LIBPATH="/usr/$(get_libdir)" \
		IGNORE_SPEED=1 \
		"$@"
}

src_compile() {
	_emake -f makefile.shared
}

src_test() {
	_emake test_standalone stest rsatest

	# We choose to be verbose during the test process
	# because the output is quite repetitive with no
	# clear demarcation b/t tests
	local tests=( "test" "stest" "rsatest" )

	local test
	for test in "${tests[@]}"; do
		einfo "Running test (${test})"
		./${test} || die "Test (${test}) failed"
		einfo "Completed test (${test})"
	done
}

src_install() {
	_emake -f makefile.shared install

	# Remove unnecessary .la files
	find "${ED}" -name '*.la' -delete || die
	# Same for static libs
	find "${ED}" -name "*.a" -delete || die
}
