# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic autotools

DESCRIPTION="GNU Ubiquitous Intelligent Language for Extensions"
HOMEPAGE="https://www.gnu.org/software/guile/"
SRC_URI="mirror://gnu/guile/${P}.tar.xz"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
LICENSE="LGPL-3+"
IUSE="debug debug-malloc +deprecated +networking +nls +regex +threads" # upstream recommended +networking +nls
# emacs useflag removal not working

REQUIRED_USE="regex"  # workaround for bug 596322
RESTRICT="strip"

RDEPEND="
	>=dev-libs/boehm-gc-7.0:=[threads?]
	dev-libs/gmp:=
	dev-libs/libffi:=
	dev-libs/libltdl:=
	dev-libs/libunistring:0=
	sys-devel/libtool
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	virtual/libcrypt:="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-apps/texinfo
	sys-devel/gettext"

SLOT="12/22" # subslot is soname version
MAJOR="2.0"

PATCHES=(
	"${FILESDIR}/${PN}-2-snarf.patch"
	"${FILESDIR}/${P}-darwin.patch"
	"${FILESDIR}/${P}-ia64-fix-crash-thread-context-switch.patch"
)

# guile generates ELF files without use of C or machine code
# It's a portage's false positive. bug #677600
QA_PREBUILT='*[.]go'

DOCS=( GUILE-VERSION HACKING README )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# see bug #178499
	filter-flags -ftree-vectorize

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
	find "${ED}" -name '*.la' -delete || die

	# From Novell
	#	https://bugzilla.novell.com/show_bug.cgi?id=874028#c0
	dodir /usr/share/gdb/auto-load/$(get_libdir)
	mv "${ED}"/usr/$(get_libdir)/libguile-*-gdb.scm "${ED}"/usr/share/gdb/auto-load/$(get_libdir) || die

	# necessary for registering slib, see bug 206896
	keepdir /usr/share/guile/site

	# Dark magic necessary for some deps
	dosym libguile-2.0.so /usr/$(get_libdir)/libguile.so
}
