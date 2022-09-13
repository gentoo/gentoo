# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# autotools for Clang 15 configure patch
inherit autotools multilib-minimal #libtool

MY_P="gc-${PV}"

DESCRIPTION="The Boehm-Demers-Weiser conservative garbage collector"
HOMEPAGE="https://www.hboehm.info/gc/ https://github.com/ivmai/bdwgc/"
SRC_URI="https://github.com/ivmai/bdwgc/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="boehm-gc"
# SONAME: libgc.so.1 libgccpp.so.1
# We've been using subslot 0 for these instead of "1.1".
SLOT="0"
# Upstream marked this version as "Pre-release"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="cxx +large static-libs +threads"

RDEPEND=">=dev-libs/libatomic_ops-7.4[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-8.2.2-clang-15-configure.patch
)

src_prepare() {
	default

	# bug #594754
	#elibtoolize

	eautoreconf
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
}
