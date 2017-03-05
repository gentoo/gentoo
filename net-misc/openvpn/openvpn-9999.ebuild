# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic user systemd linux-info git-r3

DESCRIPTION="Robust and highly flexible tunneling application compatible with many OSes"
EGIT_REPO_URI="https://github.com/OpenVPN/${PN}.git"
EGIT_SUBMODULES=(-cmocka)
HOMEPAGE="http://openvpn.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="down-root examples inotify iproute2 libressl lz4 +lzo mbedtls pam"
IUSE+=" pkcs11 +plugins polarssl selinux +ssl static systemd test userland_BSD"

REQUIRED_USE="static? ( !plugins !pkcs11 )
	lzo? ( !lz4 )
	pkcs11? ( ssl )
	mbedtls? ( ssl !libressl )
	pkcs11? ( ssl )
	!plugins? ( !pam !down-root )
	inotify? ( plugins )"

CDEPEND="
	kernel_linux? (
		iproute2? ( sys-apps/iproute2[-minimal] )
		!iproute2? ( sys-apps/net-tools )
	)
	pam? ( virtual/pam )
	ssl? (
		!mbedtls? (
			!libressl? ( >=dev-libs/openssl-0.9.8:* )
			libressl? ( dev-libs/libressl )
		)
		mbedtls? ( net-libs/mbedtls )
	)
	lz4? ( app-arch/lz4 )
	lzo? ( >=dev-libs/lzo-1.07 )
	pkcs11? ( >=dev-libs/pkcs11-helper-1.11 )
	systemd? ( sys-apps/systemd )"
DEPEND="${CDEPEND}
	test? ( dev-util/cmocka )"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-openvpn )"

CONFIG_CHECK="~TUN"

PATCHES=(
	"${FILESDIR}/${PN}-external-cmocka.patch"
)

pkg_setup()  {
	linux-info_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use static && append-ldflags -Xcompiler -static
	econf \
		--with-plugindir="${ROOT}/usr/$(get_libdir)/$PN" \
		$(usex mbedtls 'with-crypto-library' 'mbedtls' '' '') \
		$(use_enable inotify async-push) \
		$(use_enable ssl crypto) \
		$(use_enable lz4) \
		$(use_enable lzo) \
		$(use_enable pkcs11) \
		$(use_enable plugins) \
		$(use_enable iproute2) \
		$(use_enable pam plugin-auth-pam) \
		$(use_enable down-root plugin-down-root) \
		$(use_enable test tests) \
		$(use_enable systemd)
}

src_test() {
	make check || die "top-level tests failed"
	pushd tests/unit_tests > /dev/null || die
	make check || die "unit tests failed"
	popd > /dev/null || die
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

	ewarn ""
	ewarn "You are using a live ebuild building from the sources of openvpn"
	ewarn "repository from http://openvpn.git.sourceforge.net. For reporting"
	ewarn "bugs please contact: openvpn-devel@lists.sourceforge.net."
}
