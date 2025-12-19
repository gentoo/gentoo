# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a multilib-minimal libtool

MY_P="gc-${PV}"

DESCRIPTION="The Boehm-Demers-Weiser conservative garbage collector"
HOMEPAGE="https://www.hboehm.info/gc/ https://github.com/bdwgc/bdwgc/"
SRC_URI="https://github.com/bdwgc/bdwgc/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="boehm-gc"
# SONAME: libgc.so.1 libgccpp.so.1
# We've been using subslot 0 for these instead of "1.1".
SLOT="0"
# Don't keyword versions if upstream mark them as pre-release.
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="cxx +large static-libs +threads"

RDEPEND=">=dev-libs/libatomic_ops-7.4[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# bug #594754
	elibtoolize
}

src_configure() {
	use static-libs && lto-guarantee-fat
	multilib-minimal_src_configure
}

multilib_src_configure() {
	local config=(
		--disable-docs
		--with-libatomic-ops
		$(use_enable cxx cplusplus)
		$(use_enable static-libs static)
		$(use threads || echo --disable-threads)
		$(use_enable large large-config)
	)

	ECONF_SOURCE="${S}" econf "${config[@]}"
}

multilib_src_install_all() {
	local HTML_DOCS=( doc/*.md )
	einstalldocs
	dodoc doc/README{.environment,.linux,.macros}

	# Package provides .pc files
	find "${ED}" -name '*.la' -delete || die

	newman doc/gc.man GC_malloc.1

	strip-lto-bytecode
}
