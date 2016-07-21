# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit autotools confutils eutils

DESCRIPTION="AIDE (Advanced Intrusion Detection Environment) is a replacement for Tripwire"
HOMEPAGE="http://aide.sourceforge.net/"
SRC_URI="mirror://sourceforge/aide/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="acl audit curl mhash nls postgres prelink selinux static xattr zlib"

CDEPEND="acl? ( virtual/acl )
	audit? ( sys-process/audit )
	curl? ( net-misc/curl )
	mhash? ( >=app-crypt/mhash-0.9.2 )
	!mhash? ( dev-libs/libgcrypt:0 )
	nls? ( virtual/libintl )
	postgres? ( dev-db/postgresql )
	prelink? ( sys-devel/prelink )
	selinux? (
		sys-libs/libselinux
	)
	xattr? ( sys-apps/attr )
	zlib? ( sys-libs/zlib )"

RDEPEND="!static? ( ${CDEPEND} )
	selinux? ( sec-policy/selinux-aide )"

DEPEND="${CDEPEND}
	nls? ( sys-devel/gettext )
	sys-devel/bison
	sys-devel/flex"

pkg_setup() {
	confutils_use_conflict mhash postgres
	confutils_use_conflict static curl postgres
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.15.1-gentoo.patch"

	# fix as-need issue, bug #271326
	epatch "${FILESDIR}/${PN}-0.14-as-needed.patch"

	# fix configure issue, bug #323187
	epatch "${FILESDIR}/${PN}-0.14-configure.patch"

	eautoreconf
}

src_configure() {
	econf \
		$(use_with acl posix-acl) \
		$(use_with audit) \
		$(use_with curl) \
		$(use_with !mhash gcrypt) \
		$(use_with mhash mhash) \
		$(use_with nls locale) \
		$(use_with postgres psql) \
		$(use_with prelink) \
		$(use_with selinux) \
		$(use_enable static) \
		$(use_with xattr) \
		$(use_with zlib) \
		--sysconfdir="${EPREFIX}/etc/aide" || die "econf failed"
#		$(use_with e2fsattrs) \
}

src_install() {
	emake DESTDIR="${D}" install install-man || die "emake install failed"

	keepdir /var/lib/aide || die
	fowners root:0 /var/lib/aide || die
	fperms 0755 /var/lib/aide || die

	keepdir /var/log/aide || die

	insinto /etc/aide
	doins "${FILESDIR}"/aide.conf || die

	dosbin "${FILESDIR}"/aideinit || die

	dodoc AUTHORS ChangeLog NEWS README Todo "${FILESDIR}"/aide.cron || die
	dohtml doc/manual.html || die
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
