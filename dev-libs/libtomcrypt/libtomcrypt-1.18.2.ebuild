# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="LibTomCrypt is a comprehensive, modular and portable cryptographic toolkit"
HOMEPAGE="https://www.libtom.net/LibTomCrypt/ https://github.com/libtom/libtomcrypt"
SRC_URI="https://github.com/libtom/${PN}/releases/download/v${PV}/crypt-${PV}.tar.xz"
LICENSE="|| ( WTFPL-2 public-domain )"

# Current SONAME is 1
# Please bump when the ABI changes upstream
# Helpful site:
# https://abi-laboratory.pro/index.php?view=timeline&l=libtomcrypt
SLOT="1/1"

KEYWORDS="~amd64"
IUSE="+gmp +libtommath tomsfastmath"

DEPEND="
	gmp? ( dev-libs/gmp:= )
	libtommath? ( dev-libs/libtommath:= )
	tomsfastmath? ( dev-libs/tomsfastmath:= )
"
BDEPEND="virtual/pkgconfig"

_emake() {
	# Standard boilerplate
	# Upstream use homebrewed makefiles
	# Best to use same args for all, for consistency,
	# in case behaviour changes (v possible).

	local enabled_features=""
	# Build support as appropriate for consumers
	# MPI
	use gmp && enabled_features+="-DGMP_DESC=1 "
	use libtommath && enabled_features+="-DLTM_DESC=1 "
	use tomsfastmath && enabled_features+="-DTFM_DESC=1 "

	# For the test and example binaries, we have to choose
	# which MPI we want to use.
	# For now (see src_test), arbitrarily choose:
	# gmp > libtommath > tomsfastmath > none
	if use gmp ; then
		enabled_features+="-DUSE_GMP=1 "
		extralibs="-lgmp"
	elif use libtommath ; then
		enabled_features+="-DUSE_LTM=1 "
		extralibs="-ltommath"
	elif use tomsfastmath ; then
		enabled_features+="-DUSE_TFM=1 "
		extralibs="-lftm"
	fi

	# If none of the above are being used,
	# the tests don't need to link against any extra
	# libraries.
	if [[ ${FUNCNAME[1]} != "src_test" ]] ; then
		extralibs=""
	fi

	# IGNORE_SPEED=1 is needed to respect CFLAGS
	EXTRALIBS="${extralibs}" emake \
		CFLAGS="${CFLAGS} ${enabled_features}" \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		LIBPATH="/usr/$(get_libdir)" \
		INCPATH="/usr/include" \
		IGNORE_SPEED=1 \
		"$@"
}

src_compile() {
	_emake -f makefile.shared library
}

src_test() {
	# libtomcrypt can build with several MPI providers
	# but the tests can only be built with one at a time.
	# When the next release (> 1.18.2) containing
	# 1) https://github.com/libtom/libtomcrypt/commit/a65cfb8dbe4
	# 2) https://github.com/libtom/libtomcrypt/commit/fdc6cd20137
	# is made, we can run tests for each provider.
	_emake test

	./test || die "Running tests failed"
}

src_install() {
	_emake -f makefile.shared \
		DATAPATH="/usr/share" \
		DESTDIR="${ED}" \
		install install_docs

	# Remove unnecessary .la files
	find "${ED}" -name '*.la' -delete || die

	# Same for static libs
	find "${ED}" -name "*.a" -delete || die
}
