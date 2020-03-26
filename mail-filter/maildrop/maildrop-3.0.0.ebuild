# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic autotools

DESCRIPTION="Mail delivery agent/filter"
[[ -z ${PV/?.?/}   ]] && SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"
[[ -z ${PV/?.?.?/} ]] && SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"
[[ -z ${SRC_URI}   ]] && SRC_URI="https://www.courier-mta.org/beta/${PN}/${P%%_pre}.tar.bz2"
HOMEPAGE="https://www.courier-mta.org/maildrop/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 s390 sparc x86"
IUSE="berkdb debug dovecot fam gdbm ldap mysql postgres static-libs authlib +tools trashquota"

CDEPEND="!mail-mta/courier
	net-mail/mailbase
	dev-libs/libpcre
	net-dns/libidn:0=
	>=net-libs/courier-unicode-2.0
	gdbm?     ( >=sys-libs/gdbm-1.8.0 )
	mysql?    ( net-libs/courier-authlib )
	postgres? ( net-libs/courier-authlib )
	ldap?     ( net-libs/courier-authlib )
	authlib?  ( net-libs/courier-authlib )
	fam?      ( virtual/fam )
	!gdbm? (
		berkdb? ( >=sys-libs/db-3:= )
	)
	tools? (
		!mail-mta/netqmail
		!net-mail/courier-imap
		!mail-mta/mini-qmail
		!mail-mta/qmail-ldap
	)"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	dev-lang/perl
	dovecot? ( net-mail/dovecot )"
REQUIRED_USE="
	mysql? ( authlib )
	postgres? ( authlib )
	ldap? ( authlib )"

S=${WORKDIR}/${P%%_pre}

src_prepare() {
	# Prefer gdbm over berkdb
	if use gdbm ; then
		use berkdb && elog "Both gdbm and berkdb selected. Using gdbm."
	fi

	if ! use fam ; then
		eapply -p0 "${FILESDIR}"/${PN}-disable-fam.patch
	fi

	# no need to error out if no default - it will be given to econf anyway
	sed -i -e \
		's~AC_MSG_ERROR(Cannot determine default mailbox)~SPOOLDIR="./.maildir"~' \
		"${S}"/libs/maildrop/configure.ac || die "sed failed"

	eapply "${FILESDIR}"/${P}-testsuite.patch
	eapply_user
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable fam)
		--with-devel
		--disable-tempdir
		--enable-syslog=1
		--enable-use-flock=1
		--enable-use-dotlock=1
		--enable-restrict-trusted=1
		--enable-maildrop-uid=root
		--enable-maildrop-gid=mail
		--enable-sendmail=/usr/sbin/sendmail
		--cache-file="${S}"/configuring.cache
		$(use_enable static-libs static)
		$(use_enable dovecot dovecotauth)
		$(use_with trashquota)
	)

	local mytrustedusers="apache dspam root mail fetchmail"
	mytrustedusers+=" daemon postmaster qmaild mmdf vmail alias"
	myeconfargs+=( --enable-trusted-users="${mytrustedusers}" )

	# These flags make maildrop cry
	replace-flags -Os -O2
	filter-flags -fomit-frame-pointer

	if use gdbm ; then
		myeconfargs+=( --with-db=gdbm )
	elif use berkdb ; then
		myeconfargs+=( --with-db=db )
	else
		myeconfargs+=( --without-db )
	fi

	if ! use mysql && ! use postgres && ! use ldap && ! use authlib ; then
		myeconfargs+=( --disable-authlib )
	fi

	# default mailbox is $HOME/.maildir for Gentoo
	maildrop_cv_SYS_INSTALL_MBOXDIR="./.maildir" econf "${myeconfargs[@]}"
}

src_install() {
	default

	if use authlib ; then
		fperms 4755 /usr/bin/maildrop
	fi

	dodoc AUTHORS ChangeLog INSTALL NEWS README \
		README.postfix README.dovecotauth UPGRADE \
		maildroptips.txt
	docinto maildir
	dodoc libs/maildir/AUTHORS libs/maildir/INSTALL \
		libs/maildir/README*.txt libs/maildir/*.html

	# bugs 61116, 374009, and 639124
	if ! use tools ; then
		for tool in "maildirmake" "deliverquota"; do
			rm "${D}/usr/bin/${tool}" || die
			rm "${D}/usr/share/man/man"[0-9]"/${tool}."[0-9] || die
		done
		rm "${D}/usr/share/man/man5/maildir.5" || die
	fi

	insinto /etc
	doins "${FILESDIR}"/maildroprc

	use static-libs || find "${D}"/usr/lib* -name '*.la' -delete
}
