# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit multilib flag-o-matic user systemd

DESCRIPTION="Robust and highly flexible tunneling application compatible with many OSes"
SRC_URI="http://swupdate.openvpn.net/community/releases/${P}.tar.gz"
HOMEPAGE="http://openvpn.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux"
IUSE="examples down-root iproute2 +lzo pam passwordsave pkcs11 +plugins polarssl selinux socks +ssl static systemd userland_BSD"

REQUIRED_USE="static? ( !plugins !pkcs11 )
			polarssl? ( ssl )
			pkcs11? ( ssl )
			!plugins? ( !pam !down-root )"

DEPEND="
	kernel_linux? (
		iproute2? ( sys-apps/iproute2[-minimal] ) !iproute2? ( sys-apps/net-tools )
	)
	pam? ( virtual/pam )
	ssl? (
		!polarssl? ( >=dev-libs/openssl-0.9.7 ) polarssl? ( >=net-libs/polarssl-1.2.10 )
	)
	lzo? ( >=dev-libs/lzo-1.07 )
	pkcs11? ( >=dev-libs/pkcs11-helper-1.11 )
	systemd? ( sys-apps/systemd )"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-openvpn )
"

src_configure() {
	use static && LDFLAGS="${LDFLAGS} -Xcompiler -static"
	local myconf
	use polarssl && myconf="--with-crypto-library=polarssl"
	econf \
		${myconf} \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--with-plugindir="${ROOT}/usr/$(get_libdir)/$PN" \
		$(use_enable passwordsave password-save) \
		$(use_enable ssl) \
		$(use_enable ssl crypto) \
		$(use_enable lzo) \
		$(use_enable pkcs11) \
		$(use_enable plugins) \
		$(use_enable iproute2) \
		$(use_enable socks) \
		$(use_enable pam plugin-auth-pam) \
		$(use_enable down-root plugin-down-root) \
		$(use_enable systemd)
}

src_install() {
	default
	find "${ED}/usr" -name '*.la' -delete
	# install documentation
	dodoc AUTHORS ChangeLog PORTS README README.IPv6

	# Install some helper scripts
	keepdir /etc/openvpn
	exeinto /etc/openvpn
	doexe "${FILESDIR}/up.sh"
	doexe "${FILESDIR}/down.sh"

	# Install the init script and config file
	newinitd "${FILESDIR}/${PN}-2.1.init" openvpn
	newconfd "${FILESDIR}/${PN}-2.1.conf" openvpn

	# install examples, controlled by the respective useflag
	if use examples ; then
		# dodoc does not supportly support directory traversal, #15193
		insinto /usr/share/doc/${PF}/examples
		doins -r sample contrib
	fi

	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfile ${PN}.conf
	systemd_newunit distro/systemd/openvpn-client@.service openvpn-client@.service
	systemd_newunit distro/systemd/openvpn-server@.service openvpn-server@.service
}

pkg_postinst() {
	# Add openvpn user so openvpn servers can drop privs
	# Clients should run as root so they can change ip addresses,
	# dns information and other such things.
	enewgroup openvpn
	enewuser openvpn "" "" "" openvpn

	if [ path_exists -o "${ROOT}/etc/openvpn/*/local.conf" ] ; then
		ewarn "WARNING: The openvpn init script has changed"
		ewarn ""
	fi

	elog "The openvpn init script expects to find the configuration file"
	elog "openvpn.conf in /etc/openvpn along with any extra files it may need."
	elog ""
	elog "To create more VPNs, simply create a new .conf file for it and"
	elog "then create a symlink to the openvpn init script from a link called"
	elog "openvpn.newconfname - like so"
	elog "   cd /etc/openvpn"
	elog "   ${EDITOR##*/} foo.conf"
	elog "   cd /etc/init.d"
	elog "   ln -s openvpn openvpn.foo"
	elog ""
	elog "You can then treat openvpn.foo as any other service, so you can"
	elog "stop one vpn and start another if you need to."

	if grep -Eq "^[ \t]*(up|down)[ \t].*" "${ROOT}/etc/openvpn"/*.conf 2>/dev/null ; then
		ewarn ""
		ewarn "WARNING: If you use the remote keyword then you are deemed to be"
		ewarn "a client by our init script and as such we force up,down scripts."
		ewarn "These scripts call /etc/openvpn/\$SVCNAME-{up,down}.sh where you"
		ewarn "can move your scripts to."
	fi

	if use plugins ; then
		einfo ""
		einfo "plugins have been installed into /usr/$(get_libdir)/${PN}"
	fi

	einfo ""
	einfo "OpenVPN 2.3.x no longer includes the easy-rsa suite of utilities."
	einfo "They can now be emerged via app-crypt/easy-rsa."
}
