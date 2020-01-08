# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal toolchain-funcs

DESCRIPTION="Library to handle, display and manipulate GIF images"
HOMEPAGE="https://sourceforge.net/projects/giflib/"
SRC_URI="mirror://sourceforge/giflib/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/7"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs"

DEPEND="doc? ( app-text/xmlto )"

PATCHES=(
	"${FILESDIR}"/${PN}-5.1.9-gentoo.patch
	"${FILESDIR}"/${PN}-5.2.1-fix-missing-quantize-API-symbols.patch
)

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	# Use reallocarray() from libc if available.
	if $(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -D_GNU_SOURCE -o "${T}/reallocarray_test" -x c - <<< $'#include <stdlib.h>\nint main() {void *p = reallocarray(NULL, 0, 0);}' 2> /dev/null; then
		local -x CPPFLAGS="${CPPFLAGS} -D_GNU_SOURCE -DHAVE_REALLOCARRAY"
		sed -e "s/ openbsd-reallocarray\.c//" -i Makefile || die
		rm openbsd-reallocarray.c || die
	fi

	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -std=gnu99 -fPIC -Wno-format-truncation" \
		LDFLAGS="${LDFLAGS}" \
		OFLAGS="" \
		all

	if use doc && multilib_is_native_abi; then
		emake -C doc
	fi
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		install

	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi

	if use doc && multilib_is_native_abi; then
		docinto html
		dodoc doc/*.html
	fi
}

multilib_src_install_all() {
	docinto
	dodoc ChangeLog NEWS README TODO
	if use doc ; then
		dodoc doc/*.txt
		docinto html
		dodoc -r doc/whatsinagif
	fi
}

multilib_src_test() {
	emake -j1 check
}
