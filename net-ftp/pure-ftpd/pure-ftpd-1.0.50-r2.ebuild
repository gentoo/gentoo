# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Fast, production-quality, standard-conformant FTP server"
HOMEPAGE="https://www.pureftpd.org/project/pure-ftpd/"
if [[ "${PV}" == 9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/jedisct1/pure-ftpd.git"
else
	SRC_URI="
		ftp://ftp.pureftpd.org/pub/${PN}/releases/${P}.tar.bz2
		http://download.pureftpd.org/pub/${PN}/releases/${P}.tar.bz2
	"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="anondel anonperm anonren anonres caps implicittls ldap mysql noiplog pam paranoidmsg postgres resolveids selinux ssl sysquota vchroot xinetd"
REQUIRED_USE="implicittls? ( ssl )"

DEPEND="
	dev-libs/libsodium:=
	virtual/libcrypt:=
	caps? ( sys-libs/libcap )
	ldap? ( >=net-nds/openldap-2.0.25:= )
	mysql? ( || (
			dev-db/mariadb-connector-c
			dev-db/mysql-connector-c
		)
	)
	pam? ( sys-libs/pam )
	postgres? ( dev-db/postgresql:= )
	ssl? ( dev-libs/openssl:0=[-bindist(-)]	)
	sysquota? ( sys-fs/quota[-rpc] )
	xinetd? ( virtual/inetd )
"

RDEPEND="
	${DEPEND}
	net-ftp/ftpbase
	selinux? ( sec-policy/selinux-ftp )
"

BDEPEND="sys-devel/autoconf-archive"

PATCHES=( "${FILESDIR}/${PN}-1.0.28-pam.patch" )

src_prepare() {
	default

	[[ "${PV}" == 9999 ]] && eautoreconf
}

src_configure() {
	# Those features are only configurable like this, see bug #179375.
	use anondel	&& append-cppflags -DANON_CAN_DELETE
	use anonperm	&& append-cppflags -DANON_CAN_CHANGE_PERMS
	use anonren	&& append-cppflags -DANON_CAN_RENAME
	use anonres	&& append-cppflags -DANON_CAN_RESUME
	use resolveids	&& append-cppflags -DALWAYS_RESOLVE_IDS

	# Do not auto-use SSP -- let the user select this.
	export ax_cv_check_cflags___fstack_protector_all=no

	local myeconfargs=(
		--enable-largefile
		# Required for correct pid file location.
		# Pure-FTPd appends "/run/pure-ftpd.pid" to the localstatedir
		# path, and tries to write to that file even when being
		# started in foreground. So we need to pin this to /
		--localstatedir="${EPREFIX}"/
		--with-altlog
		--with-cookie
		--with-diraliases
		--with-extauth
		--with-ftpwho
		--with-language=${PUREFTPD_LANG:=english}
		--with-peruserlimits
		--with-privsep
		--with-puredb
		--with-quotas
		--with-ratios
		--with-throttling
		--with-uploadscript
		--with-virtualhosts
		$(use_with implicittls)
		$(use_with ldap)
		$(use_with mysql)
		$(use_with pam)
		$(use_with paranoidmsg)
		$(use_with postgres pgsql)
		$(use_with ssl tls)
		$(use_with sysquota sysquotas)
		$(use_with vchroot virtualchroot)
		$(usex caps '' '--without-capabilities')
		$(usex noiplog '--without-iplogging' '')
		$(usex xinetd '' '--without-inetd')
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	newinitd "${FILESDIR}/pure-ftpd.initd-r12" pure-ftpd
	newconfd "${FILESDIR}/pure-ftpd.confd-r4" pure-ftpd

	newinitd "${FILESDIR}/pure-uploadscript.initd" pure-uploadscript
	newconfd "${FILESDIR}/pure-uploadscript.confd" pure-uploadscript

	if use implicittls ; then
		sed -e '/^# Bind/s@21@990@' -i "${ED}"/etc/pure-ftpd.conf || die
	fi

	if use ssl ; then
		newinitd "${FILESDIR}/pure-certd.initd" pure-certd

		exeinto /etc
		newexe "${FILESDIR}/pure-certd.script" pure-certd.sh
	fi

	if use ldap ; then
		insinto /etc/openldap/schema
		doins pureftpd.schema
		insinto /etc/openldap
		insopts -m 0600
		doins pureftpd-ldap.conf
	fi

	if use xinetd  ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/pure-ftpd.xinetd" pure-ftpd
	fi
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		# This is a new installation
		elog
		elog "Before starting Pure-FTPd, you have to edit the /etc/pure-ftpd.conf file!"
		elog
		ewarn "It's *really* important to read the README provided with Pure-FTPd!"
		ewarn "Check out http://download.pureftpd.org/pub/pure-ftpd/doc/README for general info"
		ewarn "and http://download.pureftpd.org/pub/pure-ftpd/doc/README.TLS for SSL/TLS info."
		ewarn
	else
		for v in ${REPLACING_VERSIONS} ; do
			if ver_test "${v}" -le "1.0.50" ; then
				einfo "Configuration through /etc/conf.d/pure-ftpd is now deprecated!"
				einfo "Please migrate your settings to the new configuration file."
				einfo "Use /etc/pure-ftpd.conf to adjust your settings."
			fi
		done
	fi
}
