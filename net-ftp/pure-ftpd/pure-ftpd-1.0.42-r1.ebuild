# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils confutils flag-o-matic

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="Fast, production-quality, standard-conformant FTP server"
HOMEPAGE="http://www.pureftpd.org/"
SRC_URI="ftp://ftp.pureftpd.org/pub/${PN}/releases/${P}.tar.bz2
	http://download.pureftpd.org/pub/${PN}/releases/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"

IUSE="anondel anonperm anonren anonres caps charconv implicittls ldap libressl mysql noiplog pam paranoidmsg postgres resolveids selinux ssl sysquota vchroot xinetd"

REQUIRED_USE="implicittls? ( ssl )"

DEPEND="caps? ( sys-libs/libcap )
	charconv? ( virtual/libiconv )
	ldap? ( >=net-nds/openldap-2.0.25 )
	mysql? ( virtual/mysql )
	pam? ( virtual/pam )
	postgres? ( dev-db/postgresql:= )
	ssl? (
		!libressl? ( >=dev-libs/openssl-0.9.6g:0=[-bindist] )
		libressl? ( dev-libs/libressl:= )
	)
	sysquota? ( sys-fs/quota[-rpc] )
	xinetd? ( virtual/inetd )"

RDEPEND="${DEPEND}
	dev-libs/libsodium:=
	net-ftp/ftpbase
	selinux? ( sec-policy/selinux-ftp )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.28-pam.patch
}

src_configure() {
	# adjust max user length to something more appropriate
	# for virtual hosts. See bug #62472 for details.
	sed -e "s:# define MAX_USER_LENGTH 32U:# define MAX_USER_LENGTH 127U:" \
		-i "${S}/src/ftpd.h" || die "sed failed"

	local my_conf=""

	# Let's configure the USE-enabled stuff
	enable_extension_without	"capabilities"		"caps"
	enable_extension_with		"rfc2640"		"charconv"		0
	enable_extension_with		"ldap"			"ldap"			0
	enable_extension_with		"mysql"			"mysql"			0
	enable_extension_with		"pam"			"pam"			0
	enable_extension_with		"paranoidmsg"		"paranoidmsg"		0
	enable_extension_with		"pgsql"			"postgres"		0
	enable_extension_with		"tls"			"ssl"			0
	enable_extension_with		"implicittls"		"implicittls"		0
	enable_extension_with		"virtualchroot"		"vchroot"		0
	enable_extension_with		"sysquotas"		"sysquota"		0
	enable_extension_without	"inetd"			"xinetd"

	# noiplog is a negative flag, we don't want that enabled by default,
	# so we handle it manually, as confutils can't do that
	use noiplog && my_conf="${my_conf} --without-iplogging"

	# Those features are only configurable like this, see bug #179375.
	use anondel && append-cppflags -DANON_CAN_DELETE
	use anonperm && append-cppflags -DANON_CAN_CHANGE_PERMS
	use anonren && append-cppflags -DANON_CAN_RENAME
	use anonres && append-cppflags -DANON_CAN_RESUME
	use resolveids && append-cppflags -DALWAYS_RESOLVE_IDS

	# Do not auto-use SSP -- let the user select this.
	export ax_cv_check_cflags___fstack_protector_all=no

	econf \
		--with-altlog \
		--with-cookie \
		--with-diraliases \
		--with-extauth \
		--with-ftpwho \
		--with-language=${PUREFTPD_LANG:=english} \
		--with-peruserlimits \
		--with-privsep \
		--with-puredb \
		--with-quotas \
		--with-ratios \
		--with-throttling \
		--with-uploadscript \
		--with-virtualhosts \
		--enable-largefile \
		${my_conf}
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS CONTACT ChangeLog FAQ HISTORY INSTALL README* NEWS

	newconfd "${FILESDIR}/pure-ftpd.conf_d-3" ${PN}

	if use implicittls ; then
		sed -i '/^SERVER/s@21@990@' "${ED}"/etc/conf.d/${PN} \
			|| die "Adjusting default server port for implicittls usage failed!"
	fi

	newinitd "${FILESDIR}/pure-ftpd.rc11" pure-ftpd

	dodir /var/lib/run/${PN}

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/pure-ftpd.xinetd" pure-ftpd
	fi

	if use ldap ; then
		insinto /etc/openldap/schema
		doins pureftpd.schema
		insinto /etc/openldap
		insopts -m 0600
		doins pureftpd-ldap.conf
	fi
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		elog
		elog "Before starting Pure-FTPd, you have to edit the /etc/conf.d/pure-ftpd file!"
		elog
		ewarn "It's *really* important to read the README provided with Pure-FTPd!"
		ewarn "Check out http://download.pureftpd.org/pub/pure-ftpd/doc/README for general info"
		ewarn "and http://download.pureftpd.org/pub/pure-ftpd/doc/README.TLS for SSL/TLS info."
		ewarn
		if use charconv ; then
			ewarn "Charset conversion is an *experimental* feature!"
			ewarn "Remember to set a valid charset for your filesystem in the configuration!"
		fi
	fi
}
