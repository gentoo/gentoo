# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools prefix vcs-snapshot

MY_REL="git20161120"
MY_P="${P}.${MY_REL}"

DESCRIPTION="Text based WWW browser, supports tables and frames"
HOMEPAGE="https://github.com/tats/w3m"
SRC_URI="https://github.com/tats/${PN}/archive/v${PV}+${MY_REL}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="w3m"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="X fbcon gpm gtk imlib l10n_ja libressl lynxkeymap nls nntp ssl unicode xface"

# We cannot build w3m with gtk+2 w/o X because gtk+2 ebuild doesn't
# allow us to build w/o X, so we have to give up framebuffer w3mimg....
RDEPEND=">=dev-libs/boehm-gc-6.2:=
	>=sys-libs/ncurses-5.2-r3:0=
	>=sys-libs/zlib-1.1.3-r2
	X? (
		x11-libs/libXdmcp
		x11-libs/libXext
	)
	gtk? ( x11-libs/gdk-pixbuf )
	!gtk? (
		imlib? ( >=media-libs/imlib2-1.1.0[X] )
	)
	gpm? ( >=sys-libs/gpm-1.19.3-r5 )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	xface? ( media-libs/compface )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-underlinking.patch"
	"${FILESDIR}/${P}-fix-missing-time.patch"
)

src_prepare() {
	default
	sed -i "/^AR=/s:ar:$(tc-getAR):" {.,${PN}img,libwc}/Makefile.in
	hprefixify acinclude.m4
	eautoconf
}

src_configure() {
	local myconf=()
	local image imagelib

	if use gtk; then
		imagelib="gtk2"
	elif use imlib; then
		imagelib="imlib2"
	fi
	if [[ -n "${imagelib}" ]]; then
		use X              && image="${image}${image:+,}x11"
		use X && use fbcon && image="${image}${image:+,}fb"
	fi
	# emacs-w3m doesn't like "--enable-m17n --disable-unicode,"
	# so we better enable or disable both. Default to enable
	# m17n and unicode, see bug #47046.
	if use l10n_ja; then
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
	emake DESTDIR="${D}" install
	einstalldocs

	# http://www.sic.med.tohoku.ac.jp/~satodai/w3m-dev/200307.month/3944.html
	insinto /etc/${PN}
	newins "${FILESDIR}"/${PN}.mailcap mailcap

	insinto /usr/share/${PN}/Bonus
	doins Bonus/{*.{cgi,rb},html*,makeref}

	docinto en
	dodoc doc/{HISTORY,README,keymap,menu}*
	newdoc Bonus/README.eng README.Bonus
	docinto html/en
	dodoc doc/*.html
	if use l10n_ja; then
		docinto ja
		dodoc doc-jp/{HISTORY,README,keymap,menu}*
		newdoc Bonus/README README.Bonus
		docinto html/ja
		dodoc doc-jp/*.html
	else
		rm -rf "${ED}"/usr/share/man/ja
	fi
}
