# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools qmake-utils multilib eutils flag-o-matic toolchain-funcs

DESCRIPTION="Simple passphrase entry dialogs which utilize the Assuan protocol"
HOMEPAGE="http://gnupg.org/aegypten2/index.html"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="emacs gtk ncurses qt4 qt5 caps gnome-keyring static"

CDEPEND="
	>=dev-libs/libgpg-error-1.17
	>=dev-libs/libassuan-2.1
	>=dev-libs/libgcrypt-1.6.3
	ncurses? ( sys-libs/ncurses:0= )
	gtk? ( x11-libs/gtk+:2 )
	qt4? (
		>=dev-qt/qtgui-4.4.1:4
	     )
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	     )
	caps? ( sys-libs/libcap )
	static? ( >=sys-libs/ncurses-5.7-r5:0=[static-libs,-gpm] )
	app-eselect/eselect-pinentry
	gnome-keyring? ( app-crypt/libsecret )
"

DEPEND="${CDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
"

RDEPEND="
	${CDEPEND}
	gnome-keyring? ( app-crypt/gcr )
"

REQUIRED_USE="
	|| ( ncurses gtk qt4 qt5 )
	gtk? ( !static )
	qt4? ( !static )
	qt5? ( !static )
	static? ( ncurses )
	?? ( qt4 qt5 )
"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.8.2-ncurses.patch"\
		   "${FILESDIR}/${P}-require-CPP11-for-qt-5-7.patches"
	eautoreconf
}

src_configure() {
	local myconf=()
	use static && append-ldflags -static
	[[ "$(gcc-major-version)" -ge 5 ]] && append-cxxflags -std=gnu++11

	QT_MOC=""
	if use qt4; then
		myconf+=( --enable-pinentry-qt
			  --disable-pinentry-qt5
			)
		QT_MOC="$(qt4_get_bindir)"/moc
		# Issues finding qt on multilib systems
		export QTLIB="$(qt4_get_libdir)"
	elif use qt5; then
		myconf+=( --enable-pinentry-qt )
		QT_MOC="$(qt5_get_bindir)"/moc
		export QTLIB="$(qt5_get_libdir)"
	else
		myconf+=( --disable-pinentry-qt )
	fi

	econf \
		--enable-pinentry-tty \
		$(use_enable emacs pinentry-emacs) \
		$(use_enable gtk pinentry-gtk2) \
		$(use_enable ncurses pinentry-curses) \
		$(use_enable ncurses fallback-curses) \
		$(use_with caps libcap) \
		$(use_enable gnome-keyring libsecret) \
		$(use_enable gnome-keyring pinentry-gnome3) \
		"${myconf[@]}" \
		MOC="${QT_MOC}"
}

src_install() {
	default
	rm -f "${ED}"/usr/bin/pinentry || die

	if use qt4 || use qt5; then
		dosym pinentry-qt /usr/bin/pinentry-qt4
	fi
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
