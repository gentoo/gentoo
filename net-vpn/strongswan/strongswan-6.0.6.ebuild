# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/strongswan.asc
inherit systemd verify-sig

DESCRIPTION="IPsec-based VPN solution, supporting IKEv1/IKEv2 and MOBIKE"
HOMEPAGE="https://www.strongswan.org/"
SRC_URI="
	https://download.strongswan.org/${P}.tar.bz2
	verify-sig? ( https://download.strongswan.org/${P}.tar.bz2.sig )
"

LICENSE="GPL-2 RSA DES"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+caps curl +constraints debug dhcp eap farp gcrypt +gmp ldap mysql networkmanager +non-root +openssl selinux sqlite systemd pam pkcs11"

STRONGSWAN_PLUGINS_STD="aes cmac curve25519 des dnskey drbg eap-radius fips-prf gcm hmac led lookip md5 nonce pem pgp
pkcs1 pkcs7 pkcs8 pkcs12 pubkey random rc2 revocation sha1 sha2 sshkey systime-fix stroke unity vici x509 xcbc"
STRONGSWAN_PLUGINS_OPT_DISABLE="kdf"
STRONGSWAN_PLUGINS_OPT="acert af-alg agent addrblock aesni botan blowfish bypass-lan
ccm chapoly connmark ctr error-notify forecast files gcm ha ipseckey md4 mgf1
openxpki padlock rdrand save-keys sha3 soup test-vectors unbound whitelist xauth-noauth"

for mod in $STRONGSWAN_PLUGINS_STD; do
	IUSE="${IUSE} +strongswan_plugins_${mod}"
done

for mod in $STRONGSWAN_PLUGINS_OPT_DISABLE; do
	IUSE="${IUSE} strongswan_plugins_${mod}"
done

for mod in $STRONGSWAN_PLUGINS_OPT; do
	IUSE="${IUSE} strongswan_plugins_${mod}"
done

COMMON_DEPEND="
	non-root? (
		acct-user/ipsec
		acct-group/ipsec
	)
	dev-libs/glib:2
	gmp? ( >=dev-libs/gmp-4.1.5:= )
	gcrypt? (
		dev-libs/libgcrypt:=
		dev-libs/libgpg-error
	)
	caps? ( sys-libs/libcap )
	curl? ( net-misc/curl )
	ldap? ( net-nds/openldap:= )
	openssl? ( >=dev-libs/openssl-0.9.8:=[-bindist(-)] )
	mysql? ( dev-db/mysql-connector-c:= )
	sqlite? ( >=dev-db/sqlite-3.3.1:3 )
	systemd? ( sys-apps/systemd )
	networkmanager? ( net-misc/networkmanager )
	pam? ( sys-libs/pam )
	strongswan_plugins_botan? ( dev-libs/botan:3= )
	strongswan_plugins_connmark? ( net-firewall/iptables:= )
	strongswan_plugins_forecast? ( net-firewall/iptables:= )
	strongswan_plugins_soup? ( net-libs/libsoup:3.0 )
	strongswan_plugins_unbound? ( net-dns/unbound:= net-libs/ldns:= )
"
DEPEND="
	${COMMON_DEPEND}
	virtual/linux-sources
	sys-kernel/linux-headers
"
RDEPEND="
	${COMMON_DEPEND}
	virtual/logger
	sys-apps/iproute2
	!net-vpn/libreswan
	selinux? ( sec-policy/selinux-ipsec )
"
BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-strongswan )
"

UGID="ipsec"

src_configure() {
	local myeconfargs=(
		--disable-static
		--enable-ikev1
		--enable-ikev2
		--enable-swanctl
		--enable-socket-dynamic
		--enable-cmd
		$(use_enable curl)
		$(use_enable constraints)
		$(use_enable ldap)
		$(use_enable debug leak-detective)
		$(use_enable dhcp)
		$(use_enable eap eap-sim)
		$(use_enable eap eap-sim-file)
		$(use_enable eap eap-simaka-sql)
		$(use_enable eap eap-simaka-pseudonym)
		$(use_enable eap eap-simaka-reauth)
		$(use_enable eap eap-identity)
		$(use_enable eap eap-md5)
		$(use_enable eap eap-aka)
		$(use_enable eap eap-aka-3gpp2)
		$(use_enable eap md4)
		$(use_enable eap eap-mschapv2)
		$(use_enable eap eap-radius)
		$(use_enable eap eap-tls)
		$(use_enable eap eap-ttls)
		$(use_enable eap xauth-eap)
		$(use_enable eap eap-dynamic)
		$(use_enable farp)
		$(use_enable gmp)
		$(use_enable gcrypt)
		$(use_enable mysql)
		$(use_enable networkmanager nm)
		$(use_enable openssl)
		$(use_enable pam xauth-pam)
		$(use_enable pkcs11)
		$(use_enable sqlite)
		$(use_enable systemd)
		$(use_with caps capabilities libcap)
		--with-piddir=/run
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
	)

	if use non-root; then
		myeconfargs+=(
			--with-user=${UGID}
			--with-group=${UGID}
		)
	fi

	# If a user has already enabled db support, those plugins will
	# most likely be desired as well. Besides they don't impose new
	# dependencies and come at no cost (except for space).
	if use mysql || use sqlite; then
		myeconfargs+=(
			--enable-attr-sql
			--enable-sql
		)
	fi

	# strongSwan builds and installs static libs by default which are
	# useless to the user (and to strongSwan for that matter) because no
	# header files or alike get installed... so disabling them is safe.
	if use pam && use eap; then
		myeconfargs+=( --enable-eap-gtc )
	else
		myeconfargs+=( --disable-eap-gtc )
	fi

	for mod in $STRONGSWAN_PLUGINS_STD; do
		use strongswan_plugins_${mod} && myeconfargs+=( --enable-${mod} )
	done

	for mod in $STRONGSWAN_PLUGINS_OPT_DISABLE; do
		! use strongswan_plugins_${mod} && myeconfargs+=( --disable-${mod} )
	done

	for mod in $STRONGSWAN_PLUGINS_OPT; do
		use strongswan_plugins_${mod} && myeconfargs+=( --enable-${mod} )
	done

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	if ! use systemd; then
		rm -rf "${ED}"/lib/systemd || die "Failed removing systemd lib."
	fi

	doinitd "${FILESDIR}"/ipsec

	local dir_ugid
	if use non-root && use strongswan_plugins_stroke; then
	    if [ -f /etc/ipsec.conf ]; then
			fowners ${UGID}:${UGID} \
				/etc/ipsec.conf
		fi

		fowners ${UGID}:${UGID} \
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

	dodoc NEWS README TODO

	# shared libs are used only internally and there are no static libs,
	# so it's safe to get rid of the .la files
	find "${D}" -name '*.la' -delete || die "Failed to remove .la files."
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
		elog "This imposes a few limitations mainly to the daemon 'charon' in"
		elog "regards of the use of iptables."
		elog
		elog "Please carefully read: http://wiki.strongswan.org/projects/strongswan/wiki/ReducedPrivileges"
		elog
		elog "Thus if you require to specify a custom updown"
		elog "script to charon which requires superuser privileges, you"
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
	elog "  https://wiki.strongswan.org/projects/strongswan/wiki/KernelModules"
	elog
	elog "The up-to-date manual is available online at:"
	elog "  https://wiki.strongswan.org/"
	elog
}
