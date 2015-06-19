# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nntp/tin/tin-2.2.1.ebuild,v 1.5 2015/06/11 14:15:54 ago Exp $

EAPI=5
inherit eutils toolchain-funcs versionator

TIN_PV=$(get_version_component_range 1-2)
DESCRIPTION="A threaded NNTP and spool based UseNet newsreader"
HOMEPAGE="http://www.tin.org/"
SRC_URI="ftp://ftp.tin.org/pub/news/clients/tin/v${TIN_PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="cancel-locks debug doc +etiquette evil forgery gpg idn ipv6 mime nls sasl socks5 spell unicode"

RDEPEND="
	dev-libs/libpcre
	dev-libs/uulib
	gpg? ( app-crypt/gnupg )
	idn? ( net-dns/libidn )
	mime? ( net-mail/metamail )
	net-misc/urlview
	nls? ( sys-devel/gettext )
	sasl? ( virtual/gsasl )
	socks5? ( net-proxy/dante )
	sys-libs/ncurses[unicode?]
	unicode? ( dev-libs/icu:= )
"

DEPEND="
	${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
"

src_prepare() {
	sed -i src/Makefile.in -e 's| -s | |g' || die
	sed -i configure -e '/CFLAGS/s|-g||g' || die
}

src_configure() {
	if use evil || use cancel-locks; then
		sed -i -e"s/# -DEVIL_INSIDE/-DEVIL_INSIDE/" src/Makefile.in
	fi

	if use forgery
	then
		sed -i -e"s/^CPPFLAGS.*/& -DFORGERY/" src/Makefile.in
	fi

	local screen="ncurses"
	use unicode && screen="ncursesw"

	tc-export AR CC RANLIB

	econf \
		$(use_enable cancel-locks) \
		$(use_enable debug) \
		$(use_enable etiquette) \
		$(use_enable gpg pgp-gpg) \
		$(use_enable ipv6) \
		$(use_enable nls) \
		$(use_with mime metamail /usr) \
		$(use_with socks5 socks) $(use_with socks5) \
		$(use_with spell ispell /usr) \
		--disable-mime-strict-charset \
		--enable-echo \
		--enable-nntp-only \
		--enable-prototypes \
		--with-coffee  \
		--with-nntp-default-server="${TIN_DEFAULT_SERVER:-${NNTPSERVER:-news.gmane.org}}" \
		--with-pcre=/usr \
		--with-screen=${screen}
}

src_compile() {
	emake build
}

src_install() {
	default

	# File collision?
	rm -f "${ED}"/usr/share/man/man5/{mbox,mmdf}.5

	dodoc doc/{CHANGES{,.old},CREDITS,TODO,WHATSNEW}
	use doc && dodoc doc/{*.sample,*.txt}

	insinto /etc/tin
	doins doc/tin.defaults
}
