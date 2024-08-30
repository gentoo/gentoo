# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="ucontext implementation featuring glibc-compatible ABI"
HOMEPAGE="https://github.com/kaniini/libucontext"
SRC_URI="https://distfiles.ariadne.space/libucontext/${P}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
IUSE="+man"

BDEPEND="man? ( app-text/scdoc )"

src_compile() {
	tc-export AR CC

	arch=

	# Override arch detection
	# https://github.com/kaniini/libucontext/blob/master/Makefile#L3
	if use x86 ; then
		arch="x86"
	elif use arm ; then
		arch="arm"
	elif use arm64 ; then
		arch="aarch64"
	elif use ppc64 ; then
		arch="ppc64"
	else
		arch="$(uname -m)"
	fi

	emake \
		ARCH="${arch}" \
		LDFLAGS="${LDFLAGS}" \
		libdir="/usr/$(get_libdir)" \
		pkgconfigdir="/usr/$(get_libdir)/pkgconfig" \
		all $(usev man 'docs')
}

src_test() {
	emake \
		ARCH="${arch}" \
		LDFLAGS="${LDFLAGS}" \
		libdir="/usr/$(get_libdir)" \
		pkgconfigdir="/usr/$(get_libdir)/pkgconfig" \
		check
}

src_install() {
	emake \
		ARCH="${arch}" \
		DESTDIR="${D}" \
		prefix="${EPREFIX}/usr" \
		libdir="${EPREFIX}/usr/$(get_libdir)" \
		pkgconfigdir="${EPREFIX}/usr/$(get_libdir)/pkgconfig" \
		install $(usev man 'install_docs')

	find "${ED}" -name '*.a' -delete || die
}
