# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature toolchain-funcs

DESCRIPTION="A threaded NNTP and spool based UseNet newsreader"
HOMEPAGE="http://www.tin.org/"
SRC_URI="ftp://ftp.tin.org/pub/news/clients/tin/stable/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="cancel-locks debug gnutls gpg libtls nls sasl socks5 ssl"

RDEPEND="
	dev-libs/icu:=
	dev-libs/libpcre2:=
	dev-libs/uulib
	sys-libs/ncurses:=
	virtual/libiconv
	cancel-locks? ( >=net-libs/canlock-3.0:= )
	gpg? ( app-crypt/gnupg )
	nls? ( virtual/libintl )
	sasl? ( net-misc/gsasl[client] )
	socks5? ( net-proxy/dante )
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? (
			libtls? ( dev-libs/libretls:= )
			!libtls? ( dev-libs/openssl:= )
		)
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/yacc
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

QA_CONFIG_IMPL_DECL_SKIP=(
	# Windows only (bug #900278)
	memset_s
)

DOCS=(
	README{,.MAC,.WIN}
	doc/{CHANGES{,.old},CREDITS,TODO,WHATSNEW,filtering}
)

src_configure() {
	tc-export AR CC RANLIB
	tc-export_build_env

	# The build incorrectly discards its local -I if $CPPFLAGS is set.
	if [[ -n ${BUILD_CPPFLAGS} ]]; then
		BUILD_CPPFLAGS+=' -I$(INCDIR)'
	fi

	local myeconfargs=(
		$(use_enable cancel-locks)
		$(use_with cancel-locks canlock)

		$(use_enable debug)
		$(use_enable gpg pgp-gpg)
		$(use_enable nls)
		$(use_with socks5 socks)
		--disable-mime-strict-charset
		--enable-nntp
		--enable-prototypes
		--without-pcre
		--with-pcre2-config
		--with-coffee # easter egg :)
		--with-nntp-default-server="${TIN_DEFAULT_SERVER:-${NNTPSERVER:-news.gmane.io}}"
		--with-screen=ncursesw
	)

	if use ssl; then
		if use gnutls; then
			myeconfargs+=( --with-nntps=gnutls )
		elif use libtls; then
			myeconfargs+=( --with-nntps=libtls )
		else
			myeconfargs+=( --with-nntps=openssl )
		fi
	fi

	myeconfargs+=(
		# set default paths for utilities
		--with-editor="${EPREFIX}"/usr/libexec/editor
		--with-gpg="${EPREFIX}"/usr/bin/gpg
		--with-ispell="${EPREFIX}"/usr/bin/aspell
		--with-mailer="${EPREFIX}"/bin/mail
		--with-sum="${EPREFIX}"/usr/bin/sum

		# set default paths for directories
		--with-libdir="${EPREFIX}"/var/lib/news
		--with-spooldir="${EPREFIX}"/var/spool/news
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	# To build from the root dir you have to call `make build`, not just `make`.
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
