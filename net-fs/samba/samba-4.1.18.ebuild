# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit python-single-r1 waf-utils multilib linux-info systemd base

MY_PV="${PV/_rc/rc}"
MY_P="${PN}-${MY_PV}"

SRC_URI="mirror://samba/stable/${MY_P}.tar.gz"
KEYWORDS="~amd64 ~arm64 ~hppa ~x86"

DESCRIPTION="Samba Suite Version 4"
HOMEPAGE="http://www.samba.org/"
LICENSE="GPL-3"

SLOT="0"

IUSE="acl addns ads aio avahi client cluster cups dmapi fam gnutls iprint
ldap quota selinux syslog systemd test winbind"

# sys-apps/attr is an automagic dependency (see bug #489748)
# sys-libs/pam is an automagic dependency (see bug #489770)
CDEPEND="${PYTHON_DEPS}
	>=app-crypt/heimdal-1.5[-ssl,-threads]
	dev-libs/iniparser:0
	dev-libs/popt
	sys-libs/readline:=
	virtual/libiconv
	dev-python/subunit[${PYTHON_USEDEP}]
	sys-apps/attr
	sys-libs/libcap
	>=sys-libs/ntdb-1.0[python,${PYTHON_USEDEP}]
	>=sys-libs/ldb-1.1.17
	>=sys-libs/tdb-1.2.12[python,${PYTHON_USEDEP}]
	>=sys-libs/talloc-2.1.2[python,${PYTHON_USEDEP}]
	>=sys-libs/tevent-0.9.18
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
	systemd? ( sys-apps/systemd:0= )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	client? ( net-fs/cifs-utils[ads?] )
	selinux? ( sec-policy/selinux-samba )
"

REQUIRED_USE="ads? ( acl ldap )
	${PYTHON_REQUIRED_USE}"

RESTRICT="mirror"

S="${WORKDIR}/${MY_P}"

CONFDIR="${FILESDIR}/$(get_version_component_range 1-2)"

PATCHES=(
	"${FILESDIR}/${PN}-4.1.14-named.conf.dlz.patch"
	"${FILESDIR}/${PN}-4.0.19-automagic_aio_fix.patch"
	# support libsystemd (instead of libsystemd-daemon), bug #526362
	"${FILESDIR}/${PN}-4.1.14-libsystemd.patch"
)

WAF_BINARY="${S}/buildtools/bin/waf"

pkg_setup() {
	python-single-r1_pkg_setup
	if use aio; then
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
}

src_configure() {
	local myconf=''
	use "cluster" && myconf+=" --with-ctdb-dir=/usr"
	use "test" && myconf+=" --enable-selftest"
	myconf="${myconf} \
		--enable-fhs \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--with-modulesdir=/usr/$(get_libdir)/samba \
		--with-pammodulesdir=/$(get_libdir)/security \
		--with-piddir=/var/run/${PN} \
		--disable-rpath \
		--disable-rpath-install \
		--nopyc \
		--nopyo \
		--bundled-libraries=NONE \
		--builtin-libraries=NONE \
		$(use_with addns dnsupdate) \
		$(use_with acl acl-support) \
		$(use_with ads) \
		$(use_with aio aio-support) \
		$(use_enable avahi) \
		$(use_with cluster cluster-support) \
		$(use_enable cups) \
		$(use_with dmapi) \
		$(use_with fam) \
		$(use_enable gnutls) \
		$(use_enable iprint) \
		$(use_with ldap) \
		--with-pam \
		--with-pam_smbpass \
		$(use_with quota quotas) \
		$(use_with syslog) \
		$(use_with systemd) \
		$(use_with winbind)
		"
	use "ads" && myconf+=" --with-shared-modules=idmap_ad"

	CPPFLAGS="-I${SYSROOT}/usr/include/et ${CPPFLAGS}" \
		waf-utils_src_configure ${myconf}
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
	elog "http://samba.org/samba/history/${PN}-4.0.0.html and"
	elog "http://wiki.samba.org/index.php/Samba4/HOWTO "
}
