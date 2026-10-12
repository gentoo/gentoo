# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools multilib-minimal

DESCRIPTION="Jemalloc is a general-purpose scalable concurrent allocator"
HOMEPAGE="https://jemalloc.net/ https://github.com/jemalloc/jemalloc"
SRC_URI="https://github.com/jemalloc/jemalloc/releases/download/${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

IUSE="debug lazy-lock prof +stats xmalloc"

PATCHES=(
	"${FILESDIR}/${PN}-5.3.0-aarch64-64kib-page-size.patch" # users can override by passing `--with-lg-pagesize=foo`
	"${FILESDIR}/${PN}-5.4.0-dont-override-cflags.patch"
)

HTML_DOCS=(
	doc/jemalloc.html
)

# ./configure checks if this is defined. AFAIK this (used to) be available on
# Darwin? In any case, clock_gettime_nsec_np is one of the many gettime
# functions that is checked to be used for getting time inside jemalloc.
QA_CONFIG_IMPL_DECL_SKIP=(
	clock_gettime_nsec_np
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		# Jemalloc's headers have ABI constants hardcoded in them, so they are
		# relocated to libdir.
		--includedir="${EPREFIX}/usr/$(get_libdir)"
		$(use_enable debug)
		$(use_enable lazy-lock)
		$(use_enable prof)
		$(use_enable stats)
		$(use_enable xmalloc)
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	# Remove duplicated HTML doc from /usr/share/doc/jemalloc (already handled
	# by HTML_DOCS).
	rm -rf "${ED}"/usr/share/doc/jemalloc || die "rm failed"
}
