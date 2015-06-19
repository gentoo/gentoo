# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/netatalk/netatalk-3.1.6.ebuild,v 1.7 2015/03/31 07:53:08 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils flag-o-matic multilib pam python-r1 systemd versionator

DESCRIPTION="Open Source AFP server"
HOMEPAGE="http://netatalk.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/$(get_version_component_range 1-3)/${P}.tar.bz2"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86 ~x86-fbsd"
IUSE="acl avahi cracklib dbus debug pgp kerberos ldap pam quota samba +shadow ssl static-libs tracker tcpd +utils"

CDEPEND="
	!app-editors/yudit
	dev-libs/libevent
	>=dev-libs/libgcrypt-1.2.3:0
	sys-apps/coreutils
	>=sys-libs/db-4.2.52:=
	sys-libs/tdb
	acl? (
		sys-apps/attr
		sys-apps/acl
	)
	avahi? ( net-dns/avahi[dbus,-mdnsresponder-compat] )
	cracklib? ( sys-libs/cracklib )
	dbus? ( sys-apps/dbus dev-libs/dbus-glib )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	pam? ( virtual/pam )
	ssl? ( dev-libs/openssl:0 )
	tcpd? ( sys-apps/tcp-wrappers )
	tracker? ( app-misc/tracker )
	utils? ( ${PYTHON_DEPS} )
	"
RDEPEND="${CDEPEND}
	utils? (
		dev-lang/perl
		dev-python/dbus-python[${PYTHON_USEDEP}]
	)"
DEPEND="${CDEPEND}
	virtual/yacc
	sys-devel/flex"

RESTRICT="test"

REQUIRED_USE="
	ldap? ( acl )
	utils? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	if ! use utils; then
		sed \
			-e "s:shell_utils::g" \
			-i contrib/Makefile.am || die
	fi
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=()

	append-flags -fno-strict-aliasing

	if use acl; then
		myeconfargs+=( --with-acls $(use_with ldap) )
	else
		myeconfargs+=( --without-acls --without-ldap )
	fi

	# Ignore --with-init-style=gentoo, we install the init.d by hand and we avoid having
	# to sed the Makefiles to not do rc-update.
	# TODO:
	# systemd : --with-init-style=systemd
	myeconfargs+=(
		--disable-silent-rules
		$(use_enable avahi zeroconf)
		$(use_enable debug)
		$(use_enable debug debugging)
		$(use_enable pgp pgp-uam)
		$(use_enable kerberos)
		$(use_enable kerberos krbV-uam)
		$(use_enable quota)
		$(use_enable tcpd tcp-wrappers)
		$(use_with cracklib)
		$(use_with dbus afpstats)
		$(use_with pam)
		$(use_with samba smbsharemodes)
		$(use_with shadow)
		$(use_with ssl ssl-dir)
		$(use_with tracker)
		$(use_with tracker tracker-pkgconfig-version $(get_version_component_range 1-2 $(best_version app-misc/tracker | sed 's:app-misc/tracker-::g')))
		--enable-overwrite
		--disable-krb4-uam
		--disable-afs
		--with-libevent-header=/usr/include
		--with-libevent-lib=/usr/$(get_libdir)
		--with-bdb=/usr
		--with-uams-path=/usr/$(get_libdir)/${PN}
		--disable-silent-rules
		--with-init-style=gentoo
		--without-libevent
		--without-tdb
		--with-lockfile=/run/lock/${PN}
		)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	if use avahi; then
		sed -i -e '/avahi-daemon/s:use:need:g' "${D}"/etc/init.d/${PN} || die
	else
		sed -i -e '/avahi-daemon/d' "${D}"/etc/init.d/${PN} || die
	fi

	# The pamd file isn't what we need, use pamd_mimic_system
	rm -rf "${ED}/etc/pam.d" || die
	pamd_mimic_system netatalk auth account password session

	sed \
		-e "s|:SBINDIR:|${EPREFIX}/usr/sbin|g" \
		-e "s|:PATH_NETATALK_LOCK:|/run/lock/netatalk|g" \
		distrib/initscripts/service.systemd.tmpl \
		> "${T}"/service.systemd || die
	systemd_newunit "${T}"/service.systemd ${PN}.service

	use utils && python_foreach_impl python_doscript contrib/shell_utils/afpstats
}

pkg_postinst() {
	local fle
	if [[ ${REPLACING_VERSIONS} < 3 ]]; then
		for fle in afp_signature.conf afp_voluuid.conf; do
			if [[ -f "${ROOT}"etc/netatalk/${fle} ]]; then
				if [[ ! -f "${ROOT}"var/lib/netatalk/${fle} ]]; then
					mv \
						"${ROOT}"etc/netatalk/${fle} \
						"${ROOT}"var/lib/netatalk/
				fi
			fi
		done

		echo ""
		elog "Starting from version 3.0 only uses a single init script again"
		elog "Please update your runlevels accordingly"
		echo ""
		elog "Dependencies should be resolved automatically depending on settings"
		elog "but please report issues with this on https://bugs.gentoo.org/ if"
		elog "you find any."
		echo ""
		elog "Following config files are obsolete now:"
		elog "afpd.conf, netatalk.conf, AppleVolumes.default and afp_ldap.conf"
		elog "in favour of"
		elog "/etc/afp.conf"
		echo ""
		elog "Please convert your existing configs before you restart your daemon"
		echo ""
		elog "The new AppleDouble default backend is appledouble = ea"
		elog "Existing entries will be updated on access, but can do an offline"
		elog "conversion with"
		elog "dbd -ruve /path/to/Volume"
		echo ""
		elog "For general notes on the upgrade, please visit"
		elog "http://netatalk.sourceforge.net/3.0/htmldocs/upgrade.html"
		echo ""
	fi
}
