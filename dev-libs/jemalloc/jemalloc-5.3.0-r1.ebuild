# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="General-purpose, scalable & concurrent allocator"
HOMEPAGE="https://jemalloc.net https://github.com/jemalloc/jemalloc"
SRC_URI="https://github.com/jemalloc/jemalloc/releases/download/${PV}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0/2" # .so suffix
# used to also have ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="debug lazy-lock profile stats xmalloc"
HTML_DOCS=( doc/jemalloc.html )
PATCHES=(
	"${FILESDIR}/${PN}-5.3.0-gentoo-fixups.patch"
	"${FILESDIR}/${PN}-5.3.0-backport-pr-2312.patch"
	"${FILESDIR}/${PN}-5.3.0-backport-pr-2338.patch"
)

MULTILIB_WRAPPED_HEADERS=( /usr/include/jemalloc/jemalloc.h )

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable lazy-lock)
		$(use_enable profile prof)
		$(use_enable stats)
		$(use_enable xmalloc)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
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
			-id {"${EPREFIX}","${ED}"}/usr/$(get_libdir)/libjemalloc.2.dylib || die
	fi
	find "${ED}" -type f -name "*.a" -delete || die
}
