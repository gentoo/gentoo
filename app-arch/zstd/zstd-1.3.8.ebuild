# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal toolchain-funcs

DESCRIPTION="zstd fast compression library"
HOMEPAGE="https://facebook.github.io/zstd/"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="lz4 static-libs"

RDEPEND="app-arch/xz-utils
	lz4? ( app-arch/lz4 )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	emake -C lib \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		libzstd libzstd.a libzstd.pc

	if multilib_is_native_abi ; then
		emake \
			CC="$(tc-getCC)" \
			AR="$(tc-getAR)" \
			HAVE_LZ4=$(usex lz4 1 0) \
			PREFIX="${EPREFIX}/usr" \
			LIBDIR="${EPREFIX}/usr/$(get_libdir)" zstd

		emake -C contrib/pzstd \
			CC="$(tc-getCC)" \
			CXX="$(tc-getCXX)" \
			AR="$(tc-getAR)" \
			PREFIX="${EPREFIX}/usr" \
			LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	fi
}

multilib_src_install() {
	emake -C lib \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" install

	if multilib_is_native_abi ; then
		emake -C programs \
			DESTDIR="${D}" \
			PREFIX="${EPREFIX}/usr" \
			LIBDIR="${EPREFIX}/usr/$(get_libdir)" install

		emake -C contrib/pzstd \
			DESTDIR="${D}" \
			PREFIX="${EPREFIX}/usr" \
			LIBDIR="${EPREFIX}/usr/$(get_libdir)" install
	fi
}

multilib_src_install_all() {
	einstalldocs

	if ! use static-libs; then
		find "${ED}" -name "*.a" -delete || die
	fi
}
