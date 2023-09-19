# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature toolchain-funcs

DESCRIPTION="A threaded NNTP and spool based UseNet newsreader"
HOMEPAGE="http://www.tin.org/"
SRC_URI="ftp://ftp.tin.org/pub/news/clients/tin/stable/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="cancel-locks debug gpg nls sasl socks5"

RDEPEND="
	dev-libs/icu:=
	dev-libs/libpcre:3
	dev-libs/uulib
	sys-libs/ncurses:=[unicode(+)]
	cancel-locks? ( >=net-libs/canlock-3.0:= )
	gpg? ( app-crypt/gnupg )
	nls? ( virtual/libintl )
	sasl? ( virtual/gsasl )
	socks5? ( net-proxy/dante )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	app-alternatives/yacc
"

DOCS=(
	README{,.MAC,.WIN}
	doc/{CHANGES{,.old},CREDITS,TODO,WHATSNEW,filtering}
)

PATCHES=(
	"${FILESDIR}"/${PN}-2.6.1-configure-clang16.patch
)

src_configure() {
	tc-export AR CC RANLIB

	local myeconfargs=(
		$(use_enable cancel-locks) $(use_with cancel-locks canlock)
		$(use_enable debug)
		$(use_enable gpg pgp-gpg)
		$(use_enable nls)
		$(use_with socks5 socks) $(use_with socks5)
		--disable-mime-strict-charset
		--enable-nntp-only
		--enable-prototypes
		--with-coffee
		--with-nntp-default-server="${TIN_DEFAULT_SERVER:-${NNTPSERVER:-news.gmane.io}}"
		--with-pcre=/usr
		--with-screen=ncursesw

		# set default paths for utilities
		--with-editor="${EPREFIX}"/usr/libexec/editor
		--with-gpg="${EPREFIX}"/usr/bin/gpg
		--with-ispell="${EPREFIX}"/usr/bin/aspell
		--with-mailer="${EPREFIX}"/bin/mail
		--with-metamail="${EPREFIX}"/usr/bin/metamail
		--with-sum="${EPREFIX}"/usr/bin/sum
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	# To build from the root dir you have to call `make build`, not just
	# `make`.
	emake build
}

src_install() {
	default
	emake DESTDIR="${D}" install_sysdefs
	emake -C src DESTDIR="${D}" install_nls_man

	dodoc doc/{*.sample,*.txt}
}

pkg_postinst() {
	optfeature "spell checker support" app-text/aspell
}
