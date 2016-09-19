# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit flag-o-matic autotools

DESCRIPTION="GNU Ubiquitous Intelligent Language for Extensions"
HOMEPAGE="https://www.gnu.org/software/guile/"
SRC_URI="mirror://gnu/guile/${P}.tar.gz"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
LICENSE="LGPL-3+"
IUSE="debug debug-malloc +deprecated +networking +nls +regex +threads" # upstream recommended +networking +nls

# emacs useflag removal not working

RDEPEND="
	>=dev-libs/boehm-gc-7.0[threads?]
	dev-libs/gmp:=
	virtual/libffi
	dev-libs/libltdl:=
	dev-libs/libunistring
	sys-devel/libtool
	sys-libs/ncurses:0=
	sys-libs/readline:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-apps/texinfo
	sys-devel/gettext"

SLOT="12/22" # subslot is soname version
MAJOR="2.0"

PATCHES=( "${FILESDIR}/${P}-build_includes2.patch" ) #bug 590528 patched by upstream second try
DOCS=( GUILE-VERSION HACKING README )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# see bug #178499
	filter-flags -ftree-vectorize

	# will fail for me if posix is disabled or without modules -- hkBst
	econf \
		--disable-error-on-warning \
		--disable-rpath \
		--enable-posix \
		--with-modules \
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

	# texmacs needs this, closing bug #23493
	dodir /etc/env.d
	echo "GUILE_LOAD_PATH=\"${EPREFIX}/usr/share/guile/${MAJOR}\"" > "${ED}"/etc/env.d/50guile || die

	# necessary for registering slib, see bug 206896
	keepdir /usr/share/guile/site

	# Dark magic necessary for some deps
	dosym libguile-2.0.so /usr/$(get_libdir)/libguile.so
}

pkg_postinst() {
	[[ "${EROOT}" == "/" ]] && pkg_config
}

pkg_config() {
	if has_version '>=dev-scheme/slib-3.2.4'; then
		einfo "Registering slib with guile"
		install_slib_for_guile
	fi
}
