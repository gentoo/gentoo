# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic qmake-utils toolchain-funcs

DESCRIPTION="Simple passphrase entry dialogs which utilize the Assuan protocol"
HOMEPAGE="https://gnupg.org/aegypten2/index.html"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="caps emacs gnome-keyring fltk gtk ncurses qt5 static"

DEPEND="
	app-eselect/eselect-pinentry
	>=dev-libs/libassuan-2.1
	>=dev-libs/libgcrypt-1.6.3
	>=dev-libs/libgpg-error-1.17
	caps? ( sys-libs/libcap )
	fltk? ( x11-libs/fltk )
	gnome-keyring? ( app-crypt/libsecret )
	gtk? ( x11-libs/gtk+:2 )
	ncurses? ( sys-libs/ncurses:0= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	static? ( >=sys-libs/ncurses-5.7-r5:0=[static-libs,-gpm] )
"
RDEPEND="${DEPEND}
	gnome-keyring? ( app-crypt/gcr )
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

REQUIRED_USE="
	gtk? ( !static )
	qt5? ( !static )
"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-make-icon-work-under-Plasma-Wayland.patch"
	"${FILESDIR}/${PN}-0.8.2-ncurses.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use static && append-ldflags -static
	[[ "$(gcc-major-version)" -ge 5 ]] && append-cxxflags -std=gnu++11

	export QTLIB="$(qt5_get_libdir)"

	econf \
		$(use_enable emacs pinentry-emacs) \
		$(use_enable fltk pinentry-fltk) \
		$(use_enable gnome-keyring libsecret) \
		$(use_enable gnome-keyring pinentry-gnome3) \
		$(use_enable gtk pinentry-gtk2) \
		$(use_enable ncurses fallback-curses) \
		$(use_enable ncurses pinentry-curses) \
		$(use_enable qt5 pinentry-qt) \
		$(use_with caps libcap) \
		--enable-pinentry-tty \
		FLTK_CONFIG="${EROOT}/usr/bin/fltk-config" \
		MOC="$(qt5_get_bindir)"/moc \
		GPG_ERROR_CONFIG="${EROOT}/usr/bin/${CHOST}-gpg-error-config" \
		LIBASSUAN_CONFIG="${EROOT}/usr/bin/libassuan-config" \
		$("${S}/configure" --help | grep -- '--without-.*-prefix' | sed -e 's/^ *\([^ ]*\) .*/\1/g')
}

src_install() {
	default
	rm -f "${ED}"/usr/bin/pinentry

	use qt5 && dosym pinentry-qt /usr/bin/pinentry-qt4
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
