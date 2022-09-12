# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools prefix toolchain-funcs

MY_P="${P/_p/+git}"
MY_PV="${PV/_p/+git}"

DESCRIPTION="Text based WWW browser, supports tables and frames"
HOMEPAGE="https://github.com/tats/w3m"
SRC_URI="https://github.com/tats/w3m/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${P/_p/-git}"

LICENSE="w3m"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="fbcon gdk-pixbuf gpm imlib l10n_ja lynxkeymap nls nntp ssl unicode X xface"

REQUIRED_USE="
	fbcon? ( ?? ( gdk-pixbuf imlib ) )
	X? ( ?? ( gdk-pixbuf imlib ) )
"

RDEPEND="
	dev-libs/boehm-gc:=
	sys-libs/ncurses:0=
	sys-libs/zlib
	gdk-pixbuf? (
		x11-libs/gdk-pixbuf
		X? ( x11-libs/gdk-pixbuf-xlib )
	)
	!gdk-pixbuf? (
		imlib? ( media-libs/imlib2[X?] )
	)
	gpm? ( sys-libs/gpm )
	ssl? ( dev-libs/openssl:0= )
	X? (
		x11-base/xorg-proto
		x11-libs/libXdmcp
		x11-libs/libXext
	)
	xface? ( media-libs/compface )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.3_p20210102-restore-gettext-macro.patch
	"${FILESDIR}"/${PN}-0.5.3_p20210102-fix-configure-gettext.patch
	"${FILESDIR}"/${PN}-0.5.3_p20220429-clang-15-configure.patch
)

src_prepare() {
	default

	sed -i "/^AR=/s:ar:$(tc-getAR):" {.,${PN}img,libwc}/Makefile.in || die
	hprefixify acinclude.m4

	AT_NOEAUTOHEADER="yes" AT_M4DIR="m4" eautoreconf
}

src_configure() {
	local myconf=()
	local image imagelib

	if use gdk-pixbuf ; then
		imagelib="gtk3"
	elif use imlib ; then
		imagelib="imlib2"
	fi
	if [[ -n "${imagelib}" ]] ; then
		use X     && image="${image}${image:+,}x11"
		use fbcon && image="${image}${image:+,}fb"
	fi
	# emacs-w3m doesn't like "--enable-m17n --disable-unicode,"
	# so we better enable or disable both. Default to enable
	# m17n and unicode, see bug #47046.
	if use l10n_ja ; then
		myconf+=( --enable-japanese=$(usex unicode U E) )
	else
		myconf+=( --with-charset=$(usex unicode UTF-8 US-ASCII) )
	fi
	# lynxkeymap IUSE flag. bug #49397
	myconf+=( --enable-keymap=$(usex lynxkeymap lynx ${PN}) )

	econf \
		$(use_enable gpm mouse) \
		$(use_enable nls) \
		$(use_enable nntp) \
		$(use_enable ssl digest-auth) \
		$(use_enable xface) \
		$(use_with ssl) \
		--enable-image=${image:-no} \
		--enable-m17n \
		--enable-unicode \
		--with-browser="${EPREFIX}/usr/bin/xdg-open" \
		--with-editor="${EPREFIX}/usr/bin/vi" \
		--with-imagelib="${imagelib:-no}" \
		--with-mailer="${EPREFIX}/bin/mail" \
		--without-migemo \
		--with-termlib=yes \
		"${myconf[@]}"
}

src_install() {
	default

	insinto /etc/${PN}
	newins "${FILESDIR}"/${PN}.mailcap mailcap

	insinto /usr/share/${PN}/Bonus
	doins Bonus/{*.{cgi,rb},html*,makeref}

	docinto en
	dodoc doc/{HISTORY,README,keymap,menu}*
	newdoc Bonus/README.eng README.Bonus
	docinto html/en
	dodoc doc/*.html

	docinto de
	dodoc doc-de/README*
	docinto html/de
	dodoc doc-de/*.html

	docinto ja
	dodoc doc-jp/{HISTORY,README,keymap,menu}*
	newdoc Bonus/README README.Bonus
	docinto html/ja
	dodoc doc-jp/*.html
}
