# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="Library to handle, display and manipulate GIF images"
HOMEPAGE="https://sourceforge.net/projects/giflib/"
SRC_URI="https://downloads.sourceforge.net/giflib/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/7"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-solaris"
IUSE="doc static-libs"

BDEPEND="doc? ( virtual/imagemagick-tools )"

PATCHES=(
	"${FILESDIR}"/${PN}-5.2.1-fix-missing-quantize-API-symbols.patch
	"${FILESDIR}"/${PN}-5.2.2-fortify.patch
	"${FILESDIR}"/${PN}-5.2.2-verbose-tests.patch
)

src_prepare() {
	default

	# We don't want docs to be built unconditionally
	sed -i -e '/$(MAKE) -C doc/d' Makefile || die

	multilib_copy_sources
}

multilib_src_compile() {
	append-lfs-flags

	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -std=gnu99 -fPIC" \
		LDFLAGS="${LDFLAGS}" \
		OFLAGS="" \
		all

	if use doc && multilib_is_native_abi; then
		emake -C doc
	fi
}

multilib_src_test() {
	emake -j1 check
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
	local DOCS=( ChangeLog NEWS README TODO )
	einstalldocs
	if use doc ; then
		docinto html
		dodoc -r doc/{gifstandard,whatsinagif}
	fi
}
