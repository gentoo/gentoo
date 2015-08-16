# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit db-use eutils flag-o-matic pam

DESCRIPTION="Open Source Jabber Server"
HOMEPAGE="http://jabberd2.org"
SRC_URI="https://github.com/jabberd2/jabberd2/releases/download/jabberd-${PV}/jabberd-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="berkdb debug experimental ldap memdebug mysql pam postgres sqlite ssl test zlib"
REQUIRED_USE="memdebug? ( debug )"

# broken
RESTRICT="test"

DEPEND="dev-libs/expat
	net-libs/udns
	net-dns/libidn
	virtual/gsasl
	berkdb? ( >=sys-libs/db-4.1.25:* )
	ldap? ( net-nds/openldap )
	mysql? ( virtual/mysql )
	pam? ( virtual/pam )
	postgres? ( dev-db/postgresql:* )
	ssl? ( >=dev-libs/openssl-1.0.1:0 )
	sqlite? ( dev-db/sqlite:3 )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	>=net-im/jabber-base-0.01"
DEPEND="${DEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	test? ( dev-libs/check )"

DOCS=( AUTHORS README )

S=${WORKDIR}/jabberd-${PV}

src_prepare() {
	# Fix some default directory locations
	sed -i \
		-e 's,@localstatedir@/@package@/pid/,/var/run/@package@/,g' \
		-e 's,@localstatedir@/@package@/run/pbx,/var/run/@package@/pbx,g' \
		-e 's,@localstatedir@/@package@/log/,/var/log/@package@/,g' \
		-e 's,@localstatedir@/lib/jabberd2/fs,@localstatedir@/@package@/fs,g' \
		-e 's,@localstatedir@,/var/spool,g' \
		-e 's,@package@,jabber,g' \
		etc/{sm,router,c2s,s2s}.xml.dist.in || die "fixing default directory locations failed!"

	# If the package wasn't merged with sqlite then default to use berkdb
	use sqlite ||
		sed -i \
			-e 's,<\(module\|driver\)>sqlite<\/\1>,<\1>db</\1>,g' \
			etc/{c2s,sm}.xml.dist.in || die "setting berkdb as default failed!"

	# avoid file collision with x11-misc/screen-message wrt #453994
	sed -i \
		-e 's/@jabberd_router_bin@/jabberd2-router/' \
		-e 's/@jabberd_c2s_bin@/jabberd2-c2s/' \
		-e 's/@jabberd_s2s_bin@/jabberd2-s2s/' \
		-e 's/@jabberd_sm_bin@/jabberd2-sm/' \
		etc/jabberd*.in || die "fixing file collisions failed!"

	# rename pid files wrt #241472
	sed -i \
		-e '/pidfile/s/c2s\.pid/jabberd2-c2s\.pid/' \
		-e '/pidfile/s/router\.pid/jabberd2-router\.pid/' \
		-e '/pidfile/s/s2s\.pid/jabberd2-s2s\.pid/' \
		-e '/pidfile/s/sm\.pid/jabberd2-sm\.pid/' \
		etc/*.xml.dist.in || die "renaming pid files failed!"
}

src_configure() {
	# https://bugs.gentoo.org/show_bug.cgi?id=207655#c3
	# https://github.com/jabberd2/jabberd2/issues/34
	replace-flags -O[3s] -O2

	# --enable-pool-debug is currently broken
	econf \
		--sysconfdir=/etc/jabber \
		$(usex debug "--enable-debug" "") \
		$(usex memdebug "--enable-nad-debug" "") \
		$(use_enable ssl) \
		$(use_enable mysql) \
		$(use_enable postgres pgsql) \
		$(use_enable sqlite) \
		$(use_enable berkdb db) \
		$(use_enable ldap) \
		$(use_enable pam) \
		--enable-pipe \
		--enable-anon \
		--enable-fs \
		$(use_enable experimental) \
		$(use_enable test tests) \
		$(usex berkdb "--with-extra-include-path=$(db_includedir)" "") \
		$(use_with zlib)
}

src_install() {
	local i

	default
	prune_libtool_files --modules

	keepdir /var/spool/jabber/{fs,db}
	fowners jabber:jabber /usr/bin/{jabberd,router,sm,c2s,s2s} \
		/var/spool/jabber/{fs,db}
	fperms 770 /var/spool/jabber/{fs,db}
	fperms 750 /usr/bin/{jabberd,router,sm,c2s,s2s}

	# avoid file collision with x11-misc/screen-message wrt #453994
	for i in router sm c2s s2s ; do
		einfo "renaming /usr/bin/${i} to /usr/bin/jabberd2-${i}"
		mv "${ED%/}"/usr/bin/${i} "${ED%/}"/usr/bin/jabberd2-${i} || die
	done

	newinitd "${FILESDIR}/${PN}-2.3.2.init" jabberd
	newpamd "${FILESDIR}/${PN}-2.3.1.pamd" jabberd
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}-2.3.2.logrotate" jabberd

	docompress -x /usr/share/doc/${PF}/tools
	docinto tools
	dodoc tools/db-setup{.mysql,.pgsql,.sqlite} \
		tools/{migrate-jd14dir-2-sqlite.pl,pipe-auth.pl}

	# remove useless upstart files wrt #498900
	rm -rf "${ED%/}"/usr/etc
}

pkg_postinst() {
	if use pam; then
		echo
		ewarn 'Jabberd-2 PAM authentication requires your unix usernames to'
		ewarn 'be in the form of "contactname@jabberdomain". This behavior'
		ewarn 'is likely to change in future versions of jabberd-2. It may'
		ewarn 'be advisable to avoid PAM authentication for the time being.'
		echo
	fi

	if use sqlite || use mysql || use postgres; then
		echo
		einfo "You will need to setup or update your database using the"
		einfo "scripts in /usr/share/doc/${PF}/tools/"
		echo
	fi

	ewarn 'If you are upgrading from <=jabberd2-2.2.17 then you might have'
	ewarn 'to update /etc/jabber/jabberd.cfg via etc-update because'
	ewarn 'the binaries have been renamed to avoid file collisions!'
}
