# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Optimized and portable routines for integer theoretic applications"
HOMEPAGE="https://www.libtom.net/"
SRC_URI="https://github.com/libtom/libtommath/releases/download/v${PV}/ltm-${PV}.tar.xz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc examples static-libs"

BDEPEND="sys-devel/libtool"

src_prepare() {
	default

	# need libtool for cross compilation, bug #376643
	cat <<-EOF > configure.ac
	AC_INIT(libtommath, 0)
	AM_INIT_AUTOMAKE
	LT_INIT
	AC_CONFIG_FILES(Makefile)
	AC_OUTPUT
	EOF

	touch NEWS README AUTHORS ChangeLog Makefile.am || die

	eautoreconf

	export LIBTOOL="${S}"/libtool
}

src_configure() {
	econf $(use_enable static-libs static)
}

_emake() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		IGNORE_SPEED=1 \
		DESTDIR="${ED}" \
		LIBPATH="/usr/$(get_libdir)" \
		INCPATH="/usr/include" \
		"$@"
}

src_compile() {
	_emake -f makefile.shared
}

src_test() {
	# Tests must be built statically
	# (i.e. without -f makefile.shared)
	_emake test

	./test || die
}

src_install() {
	_emake -f makefile.shared install

	if [[ ${CHOST} == *-darwin* ]] ; then
		local path="usr/$(get_libdir)/libtommath.${PV}.dylib"
		install_name_tool -id "${EPREFIX}/${path}" "${ED}/${path}" || die "Failed to adjust install_name"
	fi

	# We only link against -lc, so drop the .la file.
	find "${ED}" -name '*.la' -delete || die
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi

	dodoc changes.txt

	use doc && dodoc doc/*.pdf

	if use examples ; then
		docinto demo
		dodoc demo/*.c
	fi
}
