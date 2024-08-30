# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

HOMEPAGE="https://www.sdaoden.eu/code.html"
DESCRIPTION="Enhanced mailx-compatible mail client based on Heirloom mailx (nail)"
LICENSE="BSD BSD-4 ISC RSA"

SRC_URI="https://ftp.sdaoden.eu/${P}.tar.xz"
SLOT="0"
KEYWORDS="amd64 ~loong ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="idn kerberos net +split-usr ssl"

RDEPEND="
	sys-libs/ncurses:0=
	virtual/libiconv
	idn? ( net-dns/libidn2 )
	net? (
		ssl? ( dev-libs/openssl:0= )
		kerberos? ( virtual/krb5 )
	)
	!mail-client/mailx
	!net-mail/mailutils
	!mail-client/nail
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils[extra-filters(+)]
	app-alternatives/awk
"

src_configure() {
	has_cflag() {
		local x var="CFLAGS[*]"
		for x in ${!var} ; do
			[[ ${x} == $1 ]] && return 0
		done
		return 1
	}

	# Fails to build without replace Bug 860357
	replace-flags -O[0gs] -O1
	# A valid -O option is necessary Bug 888613
	has_cflag -O* || append-cflags -O1
	append-cflags -std=c99
	local confopts=(
		CC="$(tc-getCC)"
		strip=/bin/true
		OPT_AUTOCC=no
		VAL_PREFIX="${EPREFIX}"/usr
		VAL_SYSCONFDIR="${EPREFIX}"/etc
		VAL_MTA="${EPREFIX}/usr/sbin/sendmail"
		VAL_MAIL='/var/spool/mail'
		VAL_PAGER=less
		$(usex idn VAL_IDNA=idn2 OPT_IDNA=no)
		VERBOSE=1
	)

	if use net; then
		confopts+=( OPT_TLS=$(usex ssl require no)
			OPT_GSSAPI=$(usex kerberos require no)
		)
	else
		confopts+=( OPT_NET=no )
	fi

	tc-is-cross-compiler && confopts+=( OPT_CROSS_BUILD=yes )

	# Cannot use emake or bad options saved Bug 879065
	make "${confopts[@]}" config || die
}

src_compile() {
	emake build
}

src_install() {
	# Use /usr/sbin/sendmail by default and provide an example
	cat <<- EOSMTP >> nail.rc

		# Use the local sendmail (/usr/sbin/sendmail) binary by default.
		# (Uncomment the following line to use a SMTP server)
		#set smtp=localhost

		# Ask for CC: list too.
		set askcc
	EOSMTP

	emake DESTDIR="${D}" install

	dodoc INSTALL NEWS README THANKS

	if use split-usr ; then
		dodir /bin
		dosym ../usr/bin/mailx /bin/mail
	fi
	dosym s-nail /usr/bin/mailx
	dosym mailx /usr/bin/mail
	dosym mailx /usr/bin/Mail

	dosym s-nail.1 /usr/share/man/man1/mailx.1
	dosym mailx.1 /usr/share/man/man1/mail.1
	dosym mailx.1 /usr/share/man/man1/Mail.1
}
