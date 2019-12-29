# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

MAJOR="2.2"
DESCRIPTION="GNU Ubiquitous Intelligent Language for Extensions"
HOMEPAGE="https://www.gnu.org/software/guile/"
SRC_URI="mirror://gnu/guile/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="12/2.2-1" # libguile-2.2.so.1 => 2.2-1
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ~ppc ppc64 ~riscv s390 ~sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug debug-malloc +deprecated +networking +nls +regex +threads" # upstream recommended +networking +nls
REQUIRED_USE="regex" # workaround for bug 596322
RESTRICT="strip"

RDEPEND="
	>=dev-libs/boehm-gc-7.0:=[threads?]
	dev-libs/gmp:=
	virtual/libffi:=
	dev-libs/libltdl:=
	dev-libs/libunistring:0=
	sys-libs/ncurses:0=
	sys-libs/readline:0="
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	sys-devel/libtool
	sys-devel/gettext"

PATCHES=( "${FILESDIR}/${PN}-2.2.3-gentoo-sandbox.patch" )
DOCS=( GUILE-VERSION HACKING README )

src_configure() {
	# see bug #178499
	filter-flags -ftree-vectorize

	# see bug #676468
	mv prebuilt/32-bit-big-endian{,.broken} || die

	econf \
		--disable-error-on-warning \
		--disable-rpath \
		--disable-static \
		--enable-posix \
		--without-libgmp-prefix \
		--without-libiconv-prefix \
		--without-libintl-prefix \
		--without-libltdl-prefix \
		--without-libreadline-prefix \
		--without-libunistring-prefix \
		$(use_enable debug guile-debug) \
		$(use_enable debug-malloc) \
		$(use_enable deprecated) \
		$(use_enable networking) \
		$(use_enable nls) \
		$(use_enable regex) \
		$(use_with threads)
}

src_install() {
	default

	# From Novell
	# 	https://bugzilla.novell.com/show_bug.cgi?id=874028#c0
	dodir /usr/share/gdb/auto-load/$(get_libdir)
	mv "${ED}"/usr/$(get_libdir)/libguile-*-gdb.scm "${ED}"/usr/share/gdb/auto-load/$(get_libdir) || die

	# necessary for registering slib, see bug 206896
	keepdir /usr/share/guile/site

	find "${D}" -name '*.la' -delete || die
}
