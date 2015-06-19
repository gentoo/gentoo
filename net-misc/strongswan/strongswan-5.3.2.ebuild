# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/strongswan/strongswan-5.3.2.ebuild,v 1.3 2015/06/11 07:17:12 ago Exp $

EAPI=5
inherit eutils linux-info systemd user

DESCRIPTION="IPsec-based VPN solution focused on security and ease of use, supporting IKEv1/IKEv2 and MOBIKE"
HOMEPAGE="http://www.strongswan.org/"
SRC_URI="http://download.strongswan.org/${P}.tar.bz2"

LICENSE="GPL-2 RSA DES"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="+caps curl +constraints debug dhcp eap farp gcrypt +gmp ldap mysql networkmanager +non-root +openssl sqlite pam pkcs11"

STRONGSWAN_PLUGINS_STD="led lookip systime-fix unity vici"
STRONGSWAN_PLUGINS_OPT="blowfish ccm ctr gcm ha ipseckey ntru padlock rdrand unbound whitelist"
for mod in $STRONGSWAN_PLUGINS_STD; do
	IUSE="${IUSE} +strongswan_plugins_${mod}"
done

for mod in $STRONGSWAN_PLUGINS_OPT; do
	IUSE="${IUSE} strongswan_plugins_${mod}"
done

COMMON_DEPEND="!net-misc/openswan
	gmp? ( >=dev-libs/gmp-4.1.5 )
	gcrypt? ( dev-libs/libgcrypt:0 )
	caps? ( sys-libs/libcap )
	curl? ( net-misc/curl )
	ldap? ( net-nds/openldap )
	openssl? ( >=dev-libs/openssl-0.9.8[-bindist] )
	mysql? ( virtual/mysql )
	sqlite? ( >=dev-db/sqlite-3.3.1 )
	networkmanager? ( net-misc/networkmanager )
	pam? ( sys-libs/pam )
	strongswan_plugins_unbound? ( net-dns/unbound )"
DEPEND="${COMMON_DEPEND}
	virtual/linux-sources
	sys-kernel/linux-headers"
RDEPEND="${COMMON_DEPEND}
	virtual/logger
	sys-apps/iproute2
	!net-misc/libreswan"

UGID="ipsec"

pkg_setup() {
	linux-info_pkg_setup
	elog "Linux kernel version: ${KV_FULL}"

	if ! kernel_is -ge 2 6 16; then
		eerror
		eerror "This ebuild currently only supports ${PN} with the"
		eerror "native Linux 2.6 IPsec stack on kernels >= 2.6.16."
		eerror
	fi

	if kernel_is -lt 2 6 34; then
		ewarn
		ewarn "IMPORTANT KERNEL NOTES: Please read carefully..."
		ewarn

		if kernel_is -lt 2 6 29; then
			ewarn "[ < 2.6.29 ] Due to a missing kernel feature, you have to"
			ewarn "include all required IPv6 modules even if you just intend"
			ewarn "to run on IPv4 only."
			ewarn
			ewarn "This has been fixed with kernels >= 2.6.29."
			ewarn
		fi

		if kernel_is -lt 2 6 33; then
			ewarn "[ < 2.6.33 ] Kernels prior to 2.6.33 include a non-standards"
			ewarn "compliant implementation for SHA-2 HMAC support in ESP and"
			ewarn "miss SHA384 and SHA512 HMAC support altogether."
			ewarn
			ewarn "If you need any of those features, please use kernel >= 2.6.33."
			ewarn
		fi

		if kernel_is -lt 2 6 34; then
			ewarn "[ < 2.6.34 ] Support for the AES-GMAC authentification-only"
			ewarn "ESP cipher is only included in kernels >= 2.6.34."
			ewarn
			ewarn "If you need it, please use kernel >= 2.6.34."
			ewarn
		fi
	fi

	if use non-root; then
		enewgroup ${UGID}
		enewuser ${UGID} -1 -1 -1 ${UGID}
	fi
}

src_prepare() {
	epatch_user
}

src_configure() {
	local myconf=""

	if use non-root; then
		myconf="${myconf} --with-user=${UGID} --with-group=${UGID}"
	fi

	# If a user has already enabled db support, those plugins will
	# most likely be desired as well. Besides they don't impose new
	# dependencies and come at no cost (except for space).
	if use mysql || use sqlite; then
		myconf="${myconf} --enable-attr-sql --enable-sql"
	fi

	# strongSwan builds and installs static libs by default which are
	# useless to the user (and to strongSwan for that matter) because no
	# header files or alike get installed... so disabling them is safe.
	if use pam && use eap; then
		myconf="${myconf} --enable-eap-gtc"
	else
		myconf="${myconf} --disable-eap-gtc"
	fi

	for mod in $STRONGSWAN_PLUGINS_STD; do
		if use strongswan_plugins_${mod}; then
			myconf+=" --enable-${mod}"
		fi
	done

	for mod in $STRONGSWAN_PLUGINS_OPT; do
		if use strongswan_plugins_${mod}; then
			myconf+=" --enable-${mod}"
		fi
	done

	econf \
		--disable-static \
		--enable-ikev1 \
		--enable-ikev2 \
		--enable-swanctl \
		--enable-socket-dynamic \
		$(use_with caps capabilities libcap) \
		$(use_enable curl) \
		$(use_enable constraints) \
		$(use_enable ldap) \
		$(use_enable debug leak-detective) \
		$(use_enable dhcp) \
		$(use_enable eap eap-sim) \
		$(use_enable eap eap-sim-file) \
		$(use_enable eap eap-simaka-sql) \
		$(use_enable eap eap-simaka-pseudonym) \
		$(use_enable eap eap-simaka-reauth) \
		$(use_enable eap eap-identity) \
		$(use_enable eap eap-md5) \
		$(use_enable eap eap-aka) \
		$(use_enable eap eap-aka-3gpp2) \
		$(use_enable eap md4) \
		$(use_enable eap eap-mschapv2) \
		$(use_enable eap eap-radius) \
		$(use_enable eap eap-tls) \
		$(use_enable eap xauth-eap) \
		$(use_enable farp) \
		$(use_enable gmp) \
		$(use_enable gcrypt) \
		$(use_enable mysql) \
		$(use_enable networkmanager nm) \
		$(use_enable openssl) \
		$(use_enable pam xauth-pam) \
		$(use_enable pkcs11) \
		$(use_enable sqlite) \
		"$(systemd_with_unitdir)" \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	doinitd "${FILESDIR}"/ipsec

	local dir_ugid
	if use non-root; then
		fowners ${UGID}:${UGID} \
			/etc/ipsec.conf \
			/etc/strongswan.conf

		dir_ugid="${UGID}"
	else
		dir_ugid="root"
	fi

	diropts -m 0750 -o ${dir_ugid} -g ${dir_ugid}
	dodir /etc/ipsec.d \
		/etc/ipsec.d/aacerts \
		/etc/ipsec.d/acerts \
		/etc/ipsec.d/cacerts \
		/etc/ipsec.d/certs \
		/etc/ipsec.d/crls \
		/etc/ipsec.d/ocspcerts \
		/etc/ipsec.d/private \
		/etc/ipsec.d/reqs

	dodoc NEWS README TODO || die

	# shared libs are used only internally and there are no static libs,
	# so it's safe to get rid of the .la files
	find "${D}" -name '*.la' -delete || die "Failed to remove .la files."
}

pkg_preinst() {
	has_version "<net-misc/strongswan-4.3.6-r1"
	upgrade_from_leq_4_3_6=$(( !$? ))

	has_version "<net-misc/strongswan-4.3.6-r1[-caps]"
	previous_4_3_6_with_caps=$(( !$? ))
}

pkg_postinst() {
	if ! use openssl && ! use gcrypt; then
		elog
		elog "${PN} has been compiled without both OpenSSL and libgcrypt support."
		elog "Please note that this might effect availability and speed of some"
		elog "cryptographic features. You are advised to enable the OpenSSL plugin."
	elif ! use openssl; then
		elog
		elog "${PN} has been compiled without the OpenSSL plugin. This might effect"
		elog "availability and speed of some cryptographic features. There will be"
		elog "no support for Elliptic Curve Cryptography (Diffie-Hellman groups 19-21,"
		elog "25, 26) and ECDSA."
	fi

	if [[ $upgrade_from_leq_4_3_6 == 1 ]]; then
		chmod 0750 "${ROOT}"/etc/ipsec.d \
			"${ROOT}"/etc/ipsec.d/aacerts \
			"${ROOT}"/etc/ipsec.d/acerts \
			"${ROOT}"/etc/ipsec.d/cacerts \
			"${ROOT}"/etc/ipsec.d/certs \
			"${ROOT}"/etc/ipsec.d/crls \
			"${ROOT}"/etc/ipsec.d/ocspcerts \
			"${ROOT}"/etc/ipsec.d/private \
			"${ROOT}"/etc/ipsec.d/reqs

		ewarn
		ewarn "The default permissions for /etc/ipsec.d/* have been tightened for"
		ewarn "security reasons. Your system installed directories have been"
		ewarn "updated accordingly. Please check if necessary."
		ewarn

		if [[ $previous_4_3_6_with_caps == 1 ]]; then
			if ! use non-root; then
				ewarn
				ewarn "IMPORTANT: You previously had ${PN} installed without root"
				ewarn "privileges because it was implied by the 'caps' USE flag."
				ewarn "This has been changed. If you want ${PN} with user privileges,"
				ewarn "you have to re-emerge it with the 'non-root' USE flag enabled."
				ewarn
			fi
		fi
	fi
	if ! use caps && ! use non-root; then
		ewarn
		ewarn "You have decided to run ${PN} with root privileges and built it"
		ewarn "without support for POSIX capability dropping. It is generally"
		ewarn "strongly suggested that you reconsider- especially if you intend"
		ewarn "to run ${PN} as server with a public ip address."
		ewarn
		ewarn "You should re-emerge ${PN} with at least the 'caps' USE flag enabled."
		ewarn
	fi
	if use non-root; then
		elog
		elog "${PN} has been installed without superuser privileges (USE=non-root)."
		elog "This imposes several limitations mainly to the IKEv1 daemon 'pluto'"
		elog "but also a few to the IKEv2 daemon 'charon'."
		elog
		elog "Please carefully read: http://wiki.strongswan.org/wiki/nonRoot"
		elog
		elog "pluto uses a helper script by default to insert/remove routing and"
		elog "policy rules upon connection start/stop which requires superuser"
		elog "privileges. charon in contrast does this internally and can do so"
		elog "even with reduced (user) privileges."
		elog
		elog "Thus if you require IKEv1 (pluto) or need to specify a custom updown"
		elog "script to pluto or charon which requires superuser privileges, you"
		elog "can work around this limitation by using sudo to grant the"
		elog "user \"ipsec\" the appropriate rights."
		elog "For example (the default case):"
		elog "/etc/sudoers:"
		elog "  ipsec ALL=(ALL) NOPASSWD: SETENV: /usr/sbin/ipsec"
		elog "Under the specific connection block in /etc/ipsec.conf:"
		elog "  leftupdown=\"sudo -E ipsec _updown iptables\""
		elog
	fi
	elog
	elog "Make sure you have _all_ required kernel modules available including"
	elog "the appropriate cryptographic algorithms. A list is available at:"
	elog "  http://wiki.strongswan.org/projects/strongswan/wiki/KernelModules"
	elog
	elog "The up-to-date manual is available online at:"
	elog "  http://wiki.strongswan.org/"
	elog
}
