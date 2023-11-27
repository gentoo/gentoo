# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gnupg.asc
inherit autotools qmake-utils verify-sig

DESCRIPTION="Simple passphrase entry dialogs which utilize the Assuan protocol"
HOMEPAGE="https://gnupg.org/aegypten2/"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"
SRC_URI+=" verify-sig? ( mirror://gnupg/${PN}/${P}.tar.bz2.sig )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="caps efl emacs gtk keyring ncurses qt5 wayland X"

DEPEND="
	>=dev-libs/libassuan-2.1
	>=dev-libs/libgcrypt-1.6.3
	>=dev-libs/libgpg-error-1.17
	efl? ( dev-libs/efl[X] )
	keyring? ( app-crypt/libsecret )
	ncurses? ( sys-libs/ncurses:= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		wayland? ( kde-plasma/kwayland:5 )
		X? (
			dev-qt/qtx11extras:5
			x11-libs/libX11
		)
	)
"
RDEPEND="
	${DEPEND}
	gtk? ( app-crypt/gcr:0[gtk] )
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-gnupg )
"
PDEPEND="emacs? ( app-emacs/pinentry )"
IDEPEND=">=app-eselect/eselect-pinentry-0.7.2"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-AR.patch"
	"${FILESDIR}/${PN}-1.2.1-automagic-capslock.patch" # bug #819939, bug #837719
)

src_prepare() {
	default

	unset FLTK_CONFIG

	eautoreconf
}

src_configure() {
	export PATH="$(qt5_get_bindir):${PATH}"
	export QTLIB="$(qt5_get_libdir)"

	local myeconfargs=(
		$(use_enable efl pinentry-efl)
		$(use_enable emacs pinentry-emacs)
		$(use_enable keyring libsecret)
		$(use_enable gtk pinentry-gnome3)
		$(use_enable ncurses fallback-curses)
		$(use_enable ncurses pinentry-curses)
		$(use_enable qt5 pinentry-qt)
		$(use_enable wayland kf5-wayland)
		$(use_enable X qtx11extras)
		$(use_with X x)

		--enable-pinentry-tty
		--disable-pinentry-fltk
		--disable-pinentry-gtk2

		MOC="$(qt5_get_bindir)"/moc
		GPG_ERROR_CONFIG="${ESYSROOT}"/usr/bin/${CHOST}-gpg-error-config
		LIBASSUAN_CONFIG="${ESYSROOT}"/usr/bin/libassuan-config

		$("${S}/configure" --help | grep -- '--without-.*-prefix' | sed -e 's/^ *\([^ ]*\) .*/\1/g')
	)

	econf "${myeconfargs[@]}"
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
