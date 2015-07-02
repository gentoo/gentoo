# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/courier-authlib/courier-authlib-0.66.3.ebuild,v 1.5 2015/07/02 04:13:10 jer Exp $

EAPI=5
inherit eutils flag-o-matic multilib user

KEYWORDS="amd64 ~arm hppa ~ppc ~ppc64 ~s390 ~sh x86 ~amd64-fbsd ~x86-fbsd"

DESCRIPTION="Courier authentication library"
SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"
HOMEPAGE="http://www.courier-mta.org/"
LICENSE="GPL-3"
SLOT="0"
IUSE="berkdb crypt debug gdbm ldap mysql pam postgres sqlite static-libs vpopmail"

RESTRICT="userpriv
	!berkdb? ( test )"

DEPEND="net-mail/mailbase
		=net-libs/courier-unicode-1.3
		gdbm? ( sys-libs/gdbm )
		!gdbm? ( sys-libs/db:= )
		dev-libs/openssl:=
		ldap? ( >=net-nds/openldap-1.2.11 )
		mysql? ( virtual/mysql )
		pam? ( virtual/pam )
		postgres? ( dev-db/postgresql:= )
		sqlite? ( dev-db/sqlite:3 )"

RDEPEND="${DEPEND}"

pkg_setup() {
	if ! has_version 'dev-tcltk/expect' ; then
		ewarn 'The dev-tcltk/expect package is not installed.'
		ewarn 'Without it, you will not be able to change system login passwords.'
		ewarn 'However non-system authentication modules (LDAP, MySQL, PostgreSQL,'
		ewarn 'and others) will work just fine.'
	fi
}

src_configure() {
	filter-flags -fomit-frame-pointer
	local myconf
	if use berkdb ; then
		if use gdbm ; then
			ewarn "Both gdbm and berkdb selected. Using gdbm."
		else
			myconf="--with-db=db"
		fi
	fi
	use gdbm && myconf="--with-db=gdbm"
	use debug && myconf+=" debug=true"
	use sqlite && myconf+=" --with-sqlite-libs"

	econf \
		--sysconfdir=/etc/courier \
		--datadir=/usr/share/courier \
		--libexecdir=/usr/$(get_libdir)/courier \
		--localstatedir=/var/lib/courier \
		--sharedstatedir=/var/lib/courier/com \
		--with-authdaemonvar=/var/lib/courier/authdaemon \
		--with-authshadow \
		--without-redhat \
		--with-mailuser=mail \
		--with-mailgroup=mail \
		--cache-file="${S}/configuring.cache" \
		$(use_with pam authpam) \
		$(use_with ldap authldap) \
		$(use_with mysql authmysql) \
		$(use_with postgres authpgsql) \
		$(use_with sqlite authsqlite) \
		${myconf}
}

orderfirst() {
	file="${D}/etc/courier/authlib/${1}" ; option="${2}" ; param="${3}"
	if [[ -e "${file}" ]] ; then
		orig="$(grep ^${option}= ${file} | cut -d\" -f 2)"
		new="${option}=\"${param} `echo ${orig} | sed -e\"s/${param}//g\" -e\"s/  / /g\"`\""
		sed -i -e "s/^${option}=.*$/${new}/" "${file}" || die
	fi
}

finduserdb() {
	for dir in \
		/etc/courier/authlib /etc/courier /etc/courier-imap \
		/usr/lib/courier/etc /usr/lib/courier-imap/etc \
		/usr/local/etc /usr/local/etc/courier /usr/local/courier/etc \
		/usr/local/lib/courier/etc /usr/local/lib/courier-imap/etc \
		/usr/local/share/sqwebmail /usr/local/etc/courier-imap ; do
		if [[ -e "${dir}/userdb" ]] ; then
			einfo "Found userdb at: ${dir}/userdb"
			cp -fR "${dir}/userdb" "${D}/etc/courier/authlib/" || die
			chmod go-rwx "${D}/etc/courier/authlib/userdb" || die
			continue
		fi
	done
}

src_install() {
	diropts -o mail -g mail
	dodir /etc/courier
	keepdir /var/lib/courier/authdaemon
	keepdir /etc/courier/authlib
	emake DESTDIR="${D}" install
	[[ ! -e "${D}/etc/courier/authlib/userdb" ]] && finduserdb
	emake DESTDIR="${D}" install-configure
	rm -f "${D}"/etc/courier/authlib/*.bak
	chown mail:mail "${D}"/etc/courier/authlib/* || die
	for y in "${D}"/etc/courier/authlib/*.dist ; do
		[[ ! -e "${y%%.dist}" ]] && cp -f "${y}" "${y%%.dist}"
	done
	use pam && orderfirst authdaemonrc authmodulelist authpam
	use ldap && orderfirst authdaemonrc authmodulelist authldap
	use sqlite && orderfirst authdaemonrc authmodulelist authsqlite
	use postgres && orderfirst authdaemonrc authmodulelist authpgsql
	use mysql && orderfirst authdaemonrc authmodulelist authmysql
	dodoc AUTHORS ChangeLog* INSTALL NEWS README
	dohtml README.html README_authlib.html NEWS.html INSTALL.html README.authdebug.html
	if use mysql ; then
		dodoc README.authmysql.myownquery
		dohtml README.authmysql.html
	fi
	if use postgres ; then
		dohtml README.authpostgres.html README.authmysql.html
	fi
	if use ldap ; then
		dodoc README.ldap
		dodir /etc/openldap/schema
		cp -f authldap.schema "${D}/etc/openldap/schema/" || die
	fi
	if use sqlite ; then
		dohtml README.authsqlite.html README.authmysql.html
	fi
	newinitd "${FILESDIR}/${PN}-r1" "${PN}"

	use static-libs || find "${D}" -name "*.a" -delete
}

pkg_postinst() {
	if [[ -e /etc/courier/authlib/userdb ]] ; then
		einfo "Running makeuserdb ..."
		chmod go-rwx /etc/courier/authlib/userdb || die
		makeuserdb
	fi
}
