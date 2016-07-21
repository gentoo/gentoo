# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools multilib eutils flag-o-matic

DESCRIPTION="Collection of simple PIN or passphrase entry dialogs which utilize the Assuan protocol"
HOMEPAGE="http://gnupg.org/aegypten2/index.html"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="gtk ncurses qt4 caps static"

RDEPEND="
	app-eselect/eselect-pinentry
	caps? ( sys-libs/libcap )
	gtk? ( x11-libs/gtk+:2 )
	ncurses? ( sys-libs/ncurses:0= )
	qt4? ( >=dev-qt/qtgui-4.4.1:4 )
	static? ( >=sys-libs/ncurses-5.7-r5:0=[static-libs,-gpm] )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	gtk? ( virtual/pkgconfig )
	qt4? ( virtual/pkgconfig )
	ppc-aix? ( dev-libs/gnulib )
"
REQUIRED_USE="
	|| ( ncurses gtk qt4 )
	gtk? ( !static )
	qt4? ( !static )
	static? ( ncurses )
"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_prepare() {
	if use qt4; then
		local f
		for f in qt4/*.moc; do
			"${EPREFIX}"/usr/bin/moc ${f/.moc/.h} > ${f} || die
		done
	fi
	epatch "${FILESDIR}/${PN}-0.8.2-ncurses.patch"
	epatch "${FILESDIR}/${PN}-0.8.2-texi.patch"
	eautoreconf
}

src_configure() {
	use static && append-ldflags -static

	if [[ ${CHOST} == *-aix* ]] ; then
		append-flags -I"${EPREFIX}/usr/$(get_libdir)/gnulib/include"
		append-ldflags -L"${EPREFIX}/usr/$(get_libdir)/gnulib/$(get_libdir)"
		append-libs -lgnu
	fi

	# Issues finding qt on multilib systems
	export QTLIB="${QTDIR}/$(get_libdir)"

	econf \
		--enable-pinentry-tty \
		$(use_enable gtk pinentry-gtk2) \
		$(use_enable ncurses pinentry-curses) \
		$(use_enable ncurses fallback-curses) \
		$(use_enable qt4 pinentry-qt4) \
		$(use_with caps libcap)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default
	rm -f "${ED}"/usr/bin/pinentry || die
}

pkg_postinst() {
	if ! has_version 'app-crypt/pinentry' || has_version '<app-crypt/pinentry-0.7.3'; then
		elog "We no longer install pinentry-curses and pinentry-qt SUID root by default."
		elog "Linux kernels >=2.6.9 support memory locking for unprivileged processes."
		elog "The soft resource limit for memory locking specifies the limit an"
		elog "unprivileged process may lock into memory. You can also use POSIX"
		elog "capabilities to allow pinentry to lock memory. To do so activate the caps"
		elog "USE flag and add the CAP_IPC_LOCK capability to the permitted set of"
		elog "your users."
	fi
	eselect pinentry update ifunset
}

pkg_postrm() {
	eselect pinentry update ifunset
}
