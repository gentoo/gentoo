# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MAJOR="3.0"
DESCRIPTION="GNU Ubiquitous Intelligent Language for Extensions"
HOMEPAGE="https://www.gnu.org/software/guile/"
SRC_URI="mirror://gnu/guile/${P}.tar.xz"

LICENSE="LGPL-3+"
SLOT="12/3.0-1" # libguile-2.2.so.1 => 2.2-1
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos"

IUSE="debug debug-malloc +deprecated +jit +networking +nls +regex +threads" # upstream recommended +networking +nls
REQUIRED_USE="regex" # workaround for bug #596322
RESTRICT="strip"

RDEPEND="
	>=dev-libs/boehm-gc-7.0[threads?]
	dev-libs/gmp:=
	dev-libs/libffi:=
	dev-libs/libatomic_ops
	dev-libs/libunistring:=
	sys-libs/ncurses:=
	sys-libs/readline:=
	virtual/libcrypt:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-build/libtool
	sys-devel/gettext
"

# guile generates ELF files without use of C or machine code
# It's false positive. bug #677600
QA_PREBUILT='*[.]go'

DOCS=( ABOUT-NLS AUTHORS ChangeLog GUILE-VERSION HACKING NEWS README THANKS )

PATCHES=( "${FILESDIR}"/${PN}-2.2.3-gentoo-sandbox.patch )

src_configure() {
	# see bug #676468
	mv prebuilt/32-bit-big-endian{,.broken} || die

	local -a myconf=(
		--disable-error-on-warning
		--disable-rpath
		--disable-lto
		--enable-posix
		--without-libgmp-prefix
		--without-libiconv-prefix
		--without-libintl-prefix
		--without-libreadline-prefix
		--without-libunistring-prefix
		$(use_enable debug guile-debug)
		$(use_enable debug-malloc)
		$(use_enable deprecated)
		$(use_enable jit)
		$(use_enable networking)
		$(use_enable nls)
		$(use_enable regex)
		$(use_with threads)
	)
	econf ${myconf[@]}
}

src_install() {
	default

	# From Novell https://bugzilla.novell.com/show_bug.cgi?id=874028#c0
	dodir /usr/share/gdb/auto-load/$(get_libdir)
	mv "${ED}"/usr/$(get_libdir)/libguile-*-gdb.scm "${ED}"/usr/share/gdb/auto-load/$(get_libdir) || die

	# necessary for registering slib, see bug #206896
	keepdir /usr/share/guile/site

	find "${ED}" -name '*.la' -delete || die
}
