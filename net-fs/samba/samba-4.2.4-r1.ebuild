# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit python-single-r1 waf-utils multilib linux-info systemd eutils

MY_PV="${PV/_rc/rc}"
MY_P="${PN}-${MY_PV}"

SRC_PATH="stable"
[[ ${PV} = *_rc* ]] && SRC_PATH="rc"

SRC_URI="mirror://samba/${SRC_PATH}/${MY_P}.tar.gz"
KEYWORDS="~amd64 ~x86"
[[ ${PV} = *_rc* ]] && KEYWORDS=""

DESCRIPTION="Samba Suite Version 4"
HOMEPAGE="http://www.samba.org/"
LICENSE="GPL-3"

SLOT="0"

IUSE="acl addc addns ads aio avahi client cluster cups dmapi fam gnutls iprint
ldap pam quota selinux syslog +system-mitkrb5 systemd test winbind"

# sys-apps/attr is an automagic dependency (see bug #489748)
# sys-libs/pam is an automagic dependency (see bug #489770)
CDEPEND="${PYTHON_DEPS}
	dev-libs/iniparser:0
	dev-libs/popt
	sys-libs/readline:=
	virtual/libiconv
	dev-python/subunit[${PYTHON_USEDEP}]
	>=net-libs/socket_wrapper-1.1.2
	sys-apps/attr
	sys-libs/libcap
	>=sys-libs/ldb-1.1.20
	sys-libs/ncurses:0=
	>=sys-libs/nss_wrapper-1.0.2
	>=sys-libs/ntdb-1.0[python,${PYTHON_USEDEP}]
	>=sys-libs/talloc-2.1.2[python,${PYTHON_USEDEP}]
	>=sys-libs/tdb-1.3.6[python,${PYTHON_USEDEP}]
	>=sys-libs/tevent-0.9.25
	>=sys-libs/uid_wrapper-1.0.1
	sys-libs/zlib
	virtual/pam
	acl? ( virtual/acl )
	addns? ( net-dns/bind-tools[gssapi] )
	aio? ( dev-libs/libaio )
	cluster? ( >=dev-db/ctdb-1.0.114_p1 )
	cups? ( net-print/cups )
	dmapi? ( sys-apps/dmapi )
	fam? ( virtual/fam )
	gnutls? ( dev-libs/libgcrypt:0
		>=net-libs/gnutls-1.4.0 )
	ldap? ( net-nds/openldap )
	system-mitkrb5? ( app-crypt/mit-krb5 )
	!system-mitkrb5? ( >=app-crypt/heimdal-1.5[-ssl] )
	systemd? ( sys-apps/systemd:0= )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	client? ( net-fs/cifs-utils[ads?] )
	selinux? ( sec-policy/selinux-samba )
"

REQUIRED_USE="addc? ( gnutls )
	ads? ( acl gnutls ldap )
	${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${PN}-4.2.3-heimdal_compilefix.patch" )

CONFDIR="${FILESDIR}/$(get_version_component_range 1-2)"

WAF_BINARY="${S}/buildtools/bin/waf"

pkg_setup() {
	python-single-r1_pkg_setup
	if use aio ; then
		if ! linux_config_exists || ! linux_chkconfig_present AIO; then
				ewarn "You must enable AIO support in your kernel config, "
				ewarn "to be able to support asynchronous I/O. "
				ewarn "You can find it at"
				ewarn
				ewarn "General Support"
				ewarn " Enable AIO support "
				ewarn
				ewarn "and recompile your kernel..."
		fi
	fi
	if ! use pam ; then
		ewarn "You have pam USE flag disabled!"
		ewarn "Unfortunately we still have to hard depend on virtual/pam as samba upstream"
		ewarn "still unconditionally links libauth4-samba4.so library to libpam.so once being"
		ewarn "found on the sytem."
		ewarn "Disabling the pam USE flag only disables installation of samba's pam authenti-"
		ewarn "cation modules."
	fi
}

src_prepare() {
	epatch ${PATCHES[@]}
}

src_configure() {
	local myconf=()
	myconf=(
		--enable-fhs
		--sysconfdir=/etc
		--localstatedir=/var
		--with-modulesdir=/usr/$(get_libdir)/samba
		--with-piddir=/var/run/${PN}
		--bundled-libraries=NONE
		--builtin-libraries=NONE
		--disable-rpath
		--disable-rpath-install
		--nopyc
		--nopyo
		$(use_with acl acl-support)
		$(usex addc '' '--without-ad-dc')
		$(use_with addns dnsupdate)
		$(use_with ads)
		$(usex ads '--with-shared-modules=idmap_ad' '')
		$(use_with aio aio-support)
		$(usex cluster '--with-ctdb-dir=/usr' '')
		$(use_enable avahi)
		$(use_with cluster cluster-support)
		$(use_enable cups)
		$(use_with dmapi)
		$(use_with fam)
		$(use_enable gnutls)
		$(use_enable iprint)
		$(use_with ldap)
		$(use_with pam)
		$(use_with pam pam_smbpass)
		$(usex pam "--with-pammodulesdir=/$(get_libdir)/security" '')
		$(use_with quota quotas)
		$(use_with syslog)
		$(use_with systemd)
		$(usex system-mitkrb5 '--with-system-mitkrb5' '')
		$(use_with winbind)
		$(usex test '--enable-selftest' '')
	)

	CPPFLAGS="-I${SYSROOT}/usr/include/et ${CPPFLAGS}" \
		waf-utils_src_configure ${myconf[@]}
}

src_install() {
	waf-utils_src_install

	# install ldap schema for server (bug #491002)
	if use ldap ; then
		insinto /etc/openldap/schema
		doins examples/LDAP/samba.schema
	fi

	# Make all .so files executable
	find "${D}" -type f -name "*.so" -exec chmod +x {} +

	# install example config file
	insinto /etc/samba
	doins examples/smb.conf.default

	# Install init script and conf.d file
	newinitd "${CONFDIR}/samba4.initd-r1" samba
	newconfd "${CONFDIR}/samba4.confd" samba

	systemd_dotmpfilesd "${FILESDIR}"/samba.conf
	systemd_dounit "${FILESDIR}"/nmbd.service
	systemd_dounit "${FILESDIR}"/smbd.{service,socket}
	systemd_newunit "${FILESDIR}"/smbd_at.service 'smbd@.service'
	systemd_dounit "${FILESDIR}"/winbindd.service
	systemd_dounit "${FILESDIR}"/samba.service
}

src_test() {
	"${WAF_BINARY}" test || die "test failed"
}

pkg_postinst() {
	ewarn "Be aware the this release contains the best of all of Samba's"
	ewarn "technology parts, both a file server (that you can reasonably expect"
	ewarn "to upgrade existing Samba 3.x releases to) and the AD domain"
	ewarn "controller work previously known as 'samba4'."

	elog "For further information and migration steps make sure to read "
	elog "http://samba.org/samba/history/${P}.html "
	elog "http://samba.org/samba/history/${PN}-4.2.0.html and"
	elog "http://wiki.samba.org/index.php/Samba4/HOWTO "
}
