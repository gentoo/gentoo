# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/aide/aide-0.13.1-r3.ebuild,v 1.12 2014/12/28 14:47:09 titanofold Exp $

inherit autotools eutils

DESCRIPTION="AIDE (Advanced Intrusion Detection Environment) is a replacement for Tripwire"
HOMEPAGE="http://aide.sourceforge.net/"
SRC_URI="mirror://sourceforge/aide/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="acl curl mhash nls postgres selinux static xattr zlib"
#IUSE="acl audit curl mhash nls postgres selinux static xattr zlib"

# libsandbox:  Can't dlopen libc: (null)
RESTRICT="test"

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

RDEPEND="!static? ( ${DEPEND} )"

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

	epatch "${FILESDIR}/${P}-gentoo.patch"

	# fix configure switch
	epatch "${FILESDIR}/${P}-configure.patch"

	# fix equal match issue, bug #204217
	epatch "${FILESDIR}/${P}-equ-matching.patch"

	# fix libgcrypt issue, bug #266175
	epatch "${FILESDIR}/${P}-libgrypt_init.patch"

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
	local myconf="
		$(use_with acl posix-acl)
		$(use_with !mhash gcrypt)
		$(use_with mhash mhash)
		$(use_with nls locale)
		$(use_with postgres psql)
		$(use_with selinux)
		$(use_enable static)
		$(use_with xattr)
		$(use_with zlib)
		--sysconfdir=/etc/aide"
#		$(use_with audit)

	# curl doesn't work with static
	use curl && ! use static && myconf="${myconf} --with-curl"

	econf ${myconf} || die "econf failed"
	# parallel make borked
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	keepdir /var/lib/aide
	fowners root:0 /var/lib/aide
	fperms 0755 /var/lib/aide

	keepdir /var/log/aide

	insinto /etc/aide
	doins "${FILESDIR}"/aide.conf

	dosbin "${FILESDIR}"/aideinit

	dodoc ChangeLog AUTHORS NEWS README "${FILESDIR}"/aide.cron
	dohtml doc/manual.html
}

pkg_postinst() {
	elog
	elog "A sample configuration file has been installed as"
	elog "/etc/aide/aide.conf.  Please edit to meet your needs."
	elog "Read the aide.conf(5) manual page for more information."
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
