# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/aide/aide-0.13.1.ebuild,v 1.19 2014/12/28 14:47:09 titanofold Exp $

inherit eutils autotools

DESCRIPTION="AIDE (Advanced Intrusion Detection Environment) is a replacement for Tripwire"
HOMEPAGE="http://aide.sourceforge.net/"
SRC_URI="mirror://sourceforge/aide/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="acl curl mhash nls postgres selinux static xattr zlib"
#IUSE="acl audit curl mhash nls postgres selinux static xattr zlib"

DEPEND="acl? ( sys-apps/acl )
	curl? ( net-misc/curl )
	mhash? ( >=app-crypt/mhash-0.9.2 )
	!mhash? ( dev-libs/libgcrypt )
	nls? ( virtual/libintl )
	postgres? ( dev-db/postgresql )
	selinux? (
		sys-libs/libselinux
		sec-policy/selinux-aide
	)
	xattr? ( sys-apps/attr )
	zlib? ( sys-libs/zlib )"
#	audit? ( sys-process/audit )

RDEPEND="!static? ( ${DEPEND} )
	virtual/mailx"

DEPEND="${DEPEND}
	nls? ( sys-devel/gettext )
	sys-devel/bison
	sys-devel/flex"

pkg_setup() {
	if use mhash && use postgres ; then
		eerror "We cannot emerge aide with mhash and postgres USE flags at the same time."
		eerror "Please remove mhash OR postgres USE flags."
		die "Please remove either mhash or postgres USE flag."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch

	if ! use mhash ; then
		# dev-libs/libgcrypt doesn't support whirlpool algorithm
		sed -i -e 's/\+whirlpool//' doc/aide.conf.in || die
	fi

	if ! use selinux ; then
		sed -i -e 's/\+selinux//' doc/aide.conf.in || die
	fi

	if ! use xattr ; then
		sed -i -e 's/\+xattrs//' doc/aide.conf.in || die
	fi

	if ! use acl ; then
		sed -i -e 's/\+acl//' doc/aide.conf.in || die
	fi
	eautoreconf
}

src_compile() {
	local myconf="--sysconfdir=/etc/aide $(use_enable static)"

	# --without-* borked
	use zlib && myconf="${myconf} --with-zlib"
	use nls  && myconf="${myconf} --with-locale"
	use postgres && myconf="${myconf} --with-psql"
	use selinux && myconf="${myconf} --with-selinux"
	use acl && myconf="${myconf} --with-posix-acl"
	use xattr && myconf="${myconf} --with-xattr"
#	use audit && myconf="${myconf} --with-audit"

	# curl doesn't work with static
	use curl && ! use static && myconf="${myconf} --with-curl"

	# If you use dev-libs/libgcrypt, --without-mhash is needed.
	use mhash \
		&& myconf="${myconf} --with-mhash" \
		|| myconf="${myconf} --with-gcrypt --without-mhash"

	econf ${myconf} || die
	# parallel make borked
	emake -j1 || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	keepdir /var/lib/aide
	keepdir /var/log/aide

	insinto /etc/aide
	doins "${FILESDIR}"/aide.conf
	# doins doc/aide.conf

	dosbin "${FILESDIR}"/aideinit

	exeinto /etc/cron.daily
	doexe "${FILESDIR}"/aide.cron

	dodoc ChangeLog AUTHORS NEWS README
	dohtml doc/manual.html
}

pkg_postinst() {
	chown root:0 /var/lib/aide
	chmod 0755 /var/lib/aide

	elog
	elog "A sample configuration file has been installed as"
	elog "/etc/aide/aide.conf.  Please edit to meet your needs."
	elog "Read the aide.conf(5) manual page for more information."
	elog "A cron file has been installed in /etc/cron.daily/aide.cron"
	elog "A helper script, aideinit, has been installed and can"
	elog "be used to make AIDE management easier. Please run"
	elog "aideinit --help for more information"
	elog

	if use postgres; then
		elog "Due to a bad assumption by aide, you must issue the following"
		elog "command after the database initialization (aide --init ...):"
		elog
		elog 'psql -c "update pg_index set indisunique=false from pg_class \\ '
		elog "  where pg_class.relname='TABLE_pkey' and \ "
		elog '  pg_class.oid=pg_index.indexrelid" -h HOSTNAME -p PORT DBASE USER'
		elog
		elog "where TABLE, HOSTNAME, PORT, DBASE, and USER are the same as"
		elog "your aide.conf."
		elog
	fi
}
