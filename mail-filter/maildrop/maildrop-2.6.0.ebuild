# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils flag-o-matic autotools

DESCRIPTION="Mail delivery agent/filter"
[[ -z ${PV/?.?/}   ]] && SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"
[[ -z ${PV/?.?.?/} ]] && SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"
[[ -z ${SRC_URI}   ]] && SRC_URI="http://www.courier-mta.org/beta/${PN}/${P%%_pre}.tar.bz2"
HOMEPAGE="http://www.courier-mta.org/maildrop/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE="berkdb debug fam gdbm ldap mysql postgres static-libs authlib +tools trashquota"

CDEPEND="!mail-mta/courier
	net-mail/mailbase
	dev-libs/libpcre
	net-dns/libidn
	gdbm?     ( >=sys-libs/gdbm-1.8.0 )
	mysql?    ( net-libs/courier-authlib )
	postgres? ( net-libs/courier-authlib )
	ldap?     ( net-libs/courier-authlib )
	authlib?  ( net-libs/courier-authlib )
	fam?      ( virtual/fam )
	!gdbm? (
		berkdb? ( >=sys-libs/db-3 )
	)
	tools? (
		!mail-mta/netqmail
		!net-mail/courier-imap
		!mail-mta/mini-qmail
	)"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	dev-lang/perl"
REQUIRED_USE="mysql? ( authlib )
			postgres? ( authlib )
			ldap? ( authlib )"

S=${WORKDIR}/${P%%_pre}

src_prepare() {
	# Prefer gdbm over berkdb
	if use gdbm ; then
		use berkdb && elog "Both gdbm and berkdb selected. Using gdbm."
	elif use berkdb ; then
		epatch "${FILESDIR}"/${PN}-2.5.1-db.patch
	fi

	if ! use fam ; then
		epatch "${FILESDIR}"/${PN}-1.8.1-disable-fam.patch
	fi

	# no need to error out if no default - it will be given to econf anyway
	sed -i -e \
		's~AC_MSG_ERROR(Cannot determine default mailbox)~SPOOLDIR="./.maildir"~' \
		"${S}"/maildrop/configure.in || die "sed failed"
	epatch "${FILESDIR}"/${PN}-testsuite.patch
	eautoreconf
}

src_configure() {
	local myconf
	local mytrustedusers="apache dspam root mail fetchmail"
	mytrustedusers+=" daemon postmaster qmaild mmdf vmail alias"

	# These flags make maildrop cry
	replace-flags -Os -O2
	filter-flags -fomit-frame-pointer

	if use gdbm ; then
		myconf="${myconf} --with-db=gdbm"
	elif use berkdb ; then
		myconf="${myconf} --with-db=db"
	else
		myconf="${myconf} --without-db"
	fi

	if ! use mysql && ! use postgres && ! use ldap && ! use authlib ; then
		myconf="${myconf} --disable-authlib"
	fi

	# Default mailbox is $HOME/.maildir for Gentoo
	maildrop_cv_SYS_INSTALL_MBOXDIR="./.maildir" econf \
		$(use_enable fam) \
		--disable-dependency-tracker \
		--with-devel \
		--disable-tempdir \
		--enable-syslog=1 \
		--enable-use-flock=1 \
		--enable-use-dotlock=1 \
		--enable-restrict-trusted=1 \
		--enable-trusted-users="${mytrustedusers}" \
		--enable-maildrop-uid=root \
		--enable-maildrop-gid=mail \
		--enable-sendmail=/usr/sbin/sendmail \
		--cache-file="${S}"/configuring.cache \
		$(use_enable static-libs static) \
		$(use_with trashquota) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	fperms 4755 /usr/bin/maildrop

	dodoc AUTHORS ChangeLog INSTALL NEWS README \
		README.postfix UPGRADE maildroptips.txt
	docinto unicode
	dodoc unicode/README
	docinto maildir
	dodoc maildir/AUTHORS maildir/INSTALL maildir/README*.txt

	# bugs #61116 #374009
	if ! use tools ; then
		for tool in "maildirmake" "deliverquota"; do
			rm "${D}/usr/bin/${tool}"
			rm "${D}/usr/share/man/man"[0-9]"/${tool}."[0-9]
			rm "${D}/usr/share/maildrop/html/${tool}.html"
		done
		rm "${D}/usr/share/man/man5/maildir.5"
	fi

	dodir "/usr/share/doc/${PF}"
	mv "${D}/usr/share/maildrop/html" "${D}/usr/share/doc/${PF}/" || die
	rm -rf "${D}"/usr/share/maildrop

	dohtml *.html maildir/*.html

	insinto /etc
	doins "${FILESDIR}"/maildroprc

	use static-libs || find "${D}"/usr/lib* -name '*.la' -delete
}
