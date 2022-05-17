# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic qmake-utils toolchain-funcs

DESCRIPTION="Simple passphrase entry dialogs which utilize the Assuan protocol"
HOMEPAGE="https://gnupg.org/aegypten2"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="caps efl emacs gnome-keyring gtk ncurses qt5"

DEPEND="
	>=app-eselect/eselect-pinentry-0.7.2
	>=dev-libs/libassuan-2.1
	>=dev-libs/libgcrypt-1.6.3
	>=dev-libs/libgpg-error-1.17
	caps? ( sys-libs/libcap )
	efl? ( dev-libs/efl[X] )
	gnome-keyring? ( app-crypt/libsecret )
	ncurses? ( sys-libs/ncurses:0= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
RDEPEND="${DEPEND}
	gtk? ( app-crypt/gcr[gtk] )
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-make-icon-work-under-Plasma-Wayland.patch"
	"${FILESDIR}/${PN}-0.8.2-ncurses.patch"
	"${FILESDIR}/${PN}-1.0.0-AR.patch"
)

src_prepare() {
	default
	unset FLTK_CONFIG
	eautoreconf
}

src_configure() {
	append-cxxflags -std=gnu++11

	export QTLIB="$(qt5_get_libdir)"

	econf \
		$(use_enable efl pinentry-efl) \
		$(use_enable emacs pinentry-emacs) \
		$(use_enable gnome-keyring libsecret) \
		$(use_enable gtk pinentry-gnome3) \
		$(use_enable ncurses fallback-curses) \
		$(use_enable ncurses pinentry-curses) \
		$(use_enable qt5 pinentry-qt) \
		$(use_with caps libcap) \
		--enable-pinentry-tty \
		--disable-pinentry-fltk \
		--disable-pinentry-gtk2 \
		MOC="$(qt5_get_bindir)"/moc \
		GPG_ERROR_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-gpg-error-config" \
		LIBASSUAN_CONFIG="${ESYSROOT}/usr/bin/libassuan-config" \
		$("${S}/configure" --help | grep -- '--without-.*-prefix' | sed -e 's/^ *\([^ ]*\) .*/\1/g')
}

src_install() {
	default
	rm "${ED}"/usr/bin/pinentry || die

	use qt5 && dosym pinentry-qt /usr/bin/pinentry-qt5
}

pkg_postinst() {
	eselect pinentry update ifunset
}

pkg_postrm() {
	eselect pinentry update ifunset
}
