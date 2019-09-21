# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools toolchain-funcs multilib-minimal

DESCRIPTION="Jemalloc is a general-purpose scalable concurrent allocator"
HOMEPAGE="http://jemalloc.net/ https://github.com/jemalloc/jemalloc"
SRC_URI="https://github.com/jemalloc/jemalloc/releases/download/${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE="debug hardened lazy-lock prof static-libs stats xmalloc"
HTML_DOCS=( doc/jemalloc.html )
PATCHES=( "${FILESDIR}/${PN}-5.2.0-gentoo-fixups.patch" )

MULTILIB_WRAPPED_HEADERS=( /usr/include/jemalloc/jemalloc.h )
# autotools-utils.eclass auto-adds configure options when static-libs is in IUSE
# but jemalloc doesn't implement them in its configure; need this here to
# supress the warnings until automagic is removed from the eclass
QA_CONFIGURE_OPTIONS="--enable-static --disable-static --enable-shared --disable-shared"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myconf=()

	if use hardened ; then
		myconf+=( --disable-syscall )
	fi

	ECONF_SOURCE="${S}" \
	econf  \
		$(use_enable debug) \
		$(use_enable lazy-lock) \
		$(use_enable prof) \
		$(use_enable stats) \
		$(use_enable xmalloc) \
		"${myconf[@]}"
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
	use static-libs || find "${ED}" -name '*.a' -delete
}
