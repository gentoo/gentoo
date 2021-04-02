# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic systemd linux-info git-r3

DESCRIPTION="Robust and highly flexible tunneling application compatible with many OSes"
EGIT_REPO_URI="https://github.com/OpenVPN/${PN}.git"
EGIT_SUBMODULES=(-cmocka)
HOMEPAGE="https://openvpn.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="down-root examples inotify iproute2 libressl lz4 +lzo mbedtls pam"
IUSE+=" pkcs11 +plugins selinux +ssl systemd test userland_BSD"

RESTRICT="!test? ( test )"
REQUIRED_USE="pkcs11? ( ssl )
	!plugins? ( !pam !down-root )
	inotify? ( plugins )
"

CDEPEND="
	kernel_linux? (
		iproute2? ( sys-apps/iproute2[-minimal] )
		!iproute2? ( >=sys-apps/net-tools-1.60_p20160215155418 )
	)
	pam? ( sys-libs/pam )
	ssl? (
		!mbedtls? (
			!libressl? ( >=dev-libs/openssl-0.9.8:0= )
			libressl? ( dev-libs/libressl:0= )
		)
		mbedtls? ( net-libs/mbedtls:= )
	)
	lz4? ( app-arch/lz4 )
	lzo? ( >=dev-libs/lzo-1.07 )
	pkcs11? ( >=dev-libs/pkcs11-helper-1.11 )
	systemd? ( sys-apps/systemd )
"
DEPEND="${CDEPEND}
	test? ( dev-util/cmocka )
"
RDEPEND="${CDEPEND}
	acct-group/openvpn
	acct-user/openvpn
	selinux? ( sec-policy/selinux-openvpn )
"

CONFIG_CHECK="~TUN"

pkg_setup() {
	linux-info_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	SYSTEMD_UNIT_DIR=$(systemd_get_systemunitdir) \
	TMPFILES_DIR="/usr/lib/tmpfiles.d" \
	econf \
		--with-plugindir="${EPREFIX}/usr/$(get_libdir)/${PN}" \
		$(use_enable inotify async-push) \
		$(use_enable ssl crypto) \
		$(use_with ssl crypto-library $(usex mbedtls mbedtls openssl)) \
		$(use_enable lz4) \
		$(use_enable lzo) \
		$(use_enable pkcs11) \
		$(use_enable plugins) \
		$(use_enable iproute2) \
		$(use_enable pam plugin-auth-pam) \
		$(use_enable down-root plugin-down-root) \
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

	find "${ED}/usr" -name '*.la' -delete || die

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
		docinto /usr/share/doc/${PF}/examples
		dodoc -r sample contrib
	fi
}

pkg_postinst() {
	if use x64-macos; then
		elog "You might want to install tuntaposx for TAP interface support:"
		elog "http://tuntaposx.sourceforge.net"
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
		einfo "plugins have been installed into /usr/$(get_libdir)/${PN}/plugins"
	fi

	ewarn ""
	ewarn "You are using a live ebuild building from the sources of openvpn"
	ewarn "repository from http://openvpn.git.sourceforge.net. For reporting"
	ewarn "bugs please contact: openvpn-devel@lists.sourceforge.net."
}
