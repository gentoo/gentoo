# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal toolchain-funcs

DESCRIPTION="Efficient I/O with io_uring"
HOMEPAGE="https://github.com/axboe/liburing"
SRC_URI="https://git.kernel.dk/cgit/${PN}/snapshot/${P}.tar.bz2"
LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~arm64 ~hppa ~ia64 ~sparc ~x86"
IUSE="static-libs"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=(
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--libdevdir="${EPREFIX}/usr/$(get_libdir)"
		--mandir="${EPREFIX}/usr/share/man"
		--cc="$(tc-getCC)"
	)
	# No autotools configure! "econf" will fail.
	TMPDIR="${T}" ./configure "${myconf[@]}"
}

multilib_src_compile() {
	emake V=1
}

multilib_src_install_all() {
	einstalldocs

	if ! use static-libs ; then
		find "${ED}" -type f -name "*.a" -delete || die
	fi
}
