# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib pam systemd

DESCRIPTION="Open Source AFP server"
HOMEPAGE="http://netatalk.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/$(ver_cut 1-3)/${P}.tar.bz2"

LICENSE="GPL-2 BSD"
SLOT="0/18.0"
KEYWORDS="amd64 arm ~ppc ~ppc64 x86"
IUSE="acl cracklib dbus debug kerberos ldap pam pgp quota samba +shadow ssl tracker tcpd zeroconf"

CDEPEND="
	!app-editors/yudit
	dev-libs/libevent:0=
	>=dev-libs/libgcrypt-1.2.3:0=
	sys-apps/coreutils
	>=sys-libs/db-4.2.52:=
	sys-libs/tdb
	virtual/libcrypt:=
	acl? (
		sys-apps/attr
		sys-apps/acl
	)
	cracklib? ( sys-libs/cracklib )
	dbus? ( sys-apps/dbus dev-libs/dbus-glib )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap:= )
	pam? ( sys-libs/pam )
	ssl? ( dev-libs/openssl:0= )
	tcpd? ( sys-apps/tcp-wrappers )
	tracker? ( app-misc/tracker:3= )
	zeroconf? ( net-dns/avahi[dbus] )
"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	virtual/yacc
	sys-devel/flex
"

RESTRICT="test"

REQUIRED_USE="
	ldap? ( acl )
	tracker? ( dbus )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.7-gentoo.patch
	"${FILESDIR}"/${PN}-3.1.8-disable-ld-library-path.patch #564350
	"${FILESDIR}"/${PN}-3.1.12-my_bool.patch #692560
	"${FILESDIR}"/${PN}-3.1.12-fno-common.patch #706852
	# https://sourceforge.net/p/netatalk/patches/147/
	"${FILESDIR}"/${PN}-3.1.12-tracker3.patch
)

src_prepare() {
	default
	append-flags -fno-strict-aliasing

	sed \
		-e "s:shell_utils::g" \
		-i contrib/Makefile.am || die

	eautoreconf
}

src_configure() {
	local myeconfargs=()

	# Ignore --with-init-style=gentoo, we install the init.d by hand and we avoid having
	# to sed the Makefiles to not do rc-update.
	# TODO:
	# systemd : --with-init-style=systemd
	myeconfargs+=(
		$(use_enable debug)
		$(use_enable debug debugging)
		$(use_enable pgp pgp-uam)
		$(use_enable kerberos)
		$(use_enable kerberos krbV-uam)
		$(use_enable quota)
		$(use_enable tcpd tcp-wrappers)
		$(use_enable zeroconf)
		$(use_with acl acls)
		$(use_with cracklib)
		$(use_with dbus afpstats)
		$(use_with ldap)
		$(use_with pam)
		$(use_with samba smbsharemodes)
		$(use_with shadow)
		$(use_with ssl ssl-dir)
		$(use_with tracker)
		$(use_with tracker dbus-daemon "${EPREFIX}/usr/bin/dbus-daemon")
		$(use_with tracker tracker-pkgconfig-version $(ver_cut 1 $(best_version app-misc/tracker | sed 's:app-misc/tracker-::g')).0)
		--disable-static
		--enable-overwrite
		--disable-krb4-uam
		--disable-afs
		--with-libevent-header=/usr/include
		--with-libevent-lib=/usr/$(get_libdir)
		--with-bdb=/usr
		--with-uams-path=/usr/$(get_libdir)/${PN}
		--with-init-style=gentoo-openrc
		--without-libevent
		--without-tdb
		--with-lockfile=/run/lock/${PN}
	)
	econf ${myeconfargs[@]}
}

src_install() {
	default

	if use zeroconf; then
		sed -i -e '/avahi-daemon/s:use:need:g' "${ED}"/etc/init.d/${PN} || die
	else
		sed -i -e '/avahi-daemon/d' "${ED}"/etc/init.d/${PN} || die
	fi

	# The pamd file isn't what we need, use pamd_mimic_system
	rm -rf "${ED}/etc/pam.d" || die

	if use pam; then
		pamd_mimic_system netatalk auth account password session
	fi

	sed \
		-e "s|:SBINDIR:|${EPREFIX}/usr/sbin|g" \
		-e "s|:PATH_NETATALK_LOCK:|/run/lock/netatalk|g" \
		distrib/initscripts/service.systemd.tmpl \
		> "${T}"/service.systemd || die
	systemd_newunit "${T}"/service.systemd ${PN}.service

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	local fle v
	for v in ${REPLACING_VERSIONS}; do
		if [[ $(ver_test ${v} -lt 3) ]]; then
			for fle in afp_signature.conf afp_voluuid.conf; do
				if [[ -f "${ROOT}"/etc/netatalk/${fle} ]]; then
					if [[ ! -f "${ROOT}"/var/lib/netatalk/${fle} ]]; then
						mv \
							"${ROOT}"/etc/netatalk/${fle} \
							"${ROOT}"/var/lib/netatalk/
					fi
				fi
			done

			elog
			elog "Starting from version 3.0 only uses a single init script again"
			elog "Please update your runlevels accordingly"
			elog
			elog "Dependencies should be resolved automatically depending on settings"
			elog "but please report issues with this on https://bugs.gentoo.org/ if"
			elog "you find any."
			elog
			elog "Following config files are obsolete now:"
			elog "afpd.conf, netatalk.conf, AppleVolumes.default and afp_ldap.conf"
			elog "in favour of"
			elog "/etc/afp.conf"
			elog
			elog "Please convert your existing configs before you restart your daemon"
			elog
			elog "The new AppleDouble default backend is appledouble = ea"
			elog "Existing entries will be updated on access, but can do an offline"
			elog "conversion with"
			elog "dbd -ruve /path/to/Volume"
			elog
			elog "For general notes on the upgrade, please visit"
			elog "http://netatalk.sourceforge.net/3.0/htmldocs/upgrade.html"
			elog
			break
		fi
	done
}
