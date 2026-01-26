# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools multilib-minimal

DESCRIPTION="Jemalloc is a general-purpose scalable concurrent allocator"
HOMEPAGE="http://jemalloc.net/ https://github.com/jemalloc/jemalloc"
SRC_URI="https://github.com/jemalloc/jemalloc/releases/download/${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="debug lazy-lock prof stats xmalloc"
HTML_DOCS=( doc/jemalloc.html )
PATCHES=(
	"${FILESDIR}/${PN}-5.3.0-gentoo-fixups.patch"
	"${FILESDIR}/${PN}-5.3.0-backport-pr-2312.patch"
	"${FILESDIR}/${PN}-5.3.0-backport-pr-2338.patch"
	"${FILESDIR}/${PN}-5.3.0-aarch64-64kib-page-size.patch" # users can override by passing `--with-lg-pagesize=foo`
)

MULTILIB_WRAPPED_HEADERS=( /usr/include/jemalloc/jemalloc.h )

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		$(use_enable debug)
		$(use_enable lazy-lock)
		$(use_enable prof)
		$(use_enable stats)
		$(use_enable xmalloc)
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install() {
	# Copy man file which the Makefile looks for
	cp "${S}/doc/jemalloc.3" "${BUILD_DIR}/doc" || die
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	if [[ ${CHOST} == *-darwin* ]] ; then
		# fixup install_name, #437362
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libjemalloc.2.dylib \
			"${ED}"/usr/$(get_libdir)/libjemalloc.2.dylib || die
	fi
	find "${ED}" -name '*.a' -delete || die
}
