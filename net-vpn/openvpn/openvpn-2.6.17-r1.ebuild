# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools dot-a systemd linux-info tmpfiles

DESCRIPTION="Robust and highly flexible tunneling application compatible with many OSes"
HOMEPAGE="https://community.openvpn.net/ https://openvpn.net"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/OpenVPN/${PN}.git"
	inherit git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/openvpn.asc
	inherit verify-sig

	SRC_URI="
		https://build.openvpn.net/downloads/releases/${P}.tar.gz
		verify-sig? ( https://build.openvpn.net/downloads/releases/${P}.tar.gz.asc )
	"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="dco down-root examples inotify iproute2 +lz4 +lzo mbedtls +openssl"
IUSE+=" pam pkcs11 +plugins selinux systemd test"

RESTRICT="!test? ( test )"
REQUIRED_USE="
	^^ ( openssl mbedtls )
	pkcs11? ( !mbedtls )
	!plugins? ( !pam !down-root )
	inotify? ( plugins )
	dco? ( !iproute2 )
"

COMMON_DEPEND="
	kernel_linux? (
		iproute2? ( sys-apps/iproute2[-minimal] )
	)
	lz4? ( app-arch/lz4 )
	lzo? ( >=dev-libs/lzo-1.07 )
	mbedtls? ( net-libs/mbedtls:0= )
	openssl? ( >=dev-libs/openssl-1.0.2:0= )
	pam? ( sys-libs/pam )
	pkcs11? ( >=dev-libs/pkcs11-helper-1.11 )
	systemd? ( sys-apps/systemd )
	dco? ( >=net-vpn/ovpn-dco-0.2 >=dev-libs/libnl-3.2.29:= )
	sys-libs/libcap-ng:=
"

BDEPEND="
	virtual/pkgconfig
"

DEPEND="
	${COMMON_DEPEND}
	test? ( dev-util/cmocka )
"
RDEPEND="
	${COMMON_DEPEND}
	acct-group/openvpn
	acct-user/openvpn
	selinux? ( sec-policy/selinux-openvpn )
"

if [[ ${PV} = "9999" ]]; then
	BDEPEND+=" dev-python/docutils"
else
	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-openvpn )"
fi

PATCHES=(
	"${FILESDIR}"/${PN}-2.6.17-tests-no-lto.patch
)

pkg_setup() {
	local CONFIG_CHECK="~TUN"
	linux-info_pkg_setup
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local -a myeconfargs

	# See tests-no-lto.patch (done unconditionally to not have the build
	# vary with and without tests)
	lto-guarantee-fat

	if ! use mbedtls; then
		myeconfargs+=(
			$(use_enable pkcs11)
		)
	fi

	myeconfargs+=(
		$(use_enable inotify async-push)
		--with-crypto-library=$(usex mbedtls mbedtls openssl)
		$(use_enable lz4)
		$(use_enable lzo)
		$(use_enable plugins)
		$(use_enable iproute2)
		$(use_enable pam plugin-auth-pam)
		$(use_enable down-root plugin-down-root)
		$(use_enable systemd)
		$(use_enable dco)
	)

	SYSTEMD_UNIT_DIR=$(systemd_get_systemunitdir) \
		TMPFILES_DIR="/usr/lib/tmpfiles.d" \
		IPROUTE=$(usex iproute2 '/bin/ip' '') \
		econf "${myeconfargs[@]}"
}

src_test() {
	local -x RUN_SUDO=false

	elog "Running top-level tests"
	emake check

	pushd tests/unit_tests &>/dev/null || die
	elog "Running unit tests"
	emake check
	popd &>/dev/null || die
}

src_install() {
	default

	find "${ED}/usr" -name '*.la' -delete || die

	# install documentation
	dodoc AUTHORS ChangeLog PORTS README

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
		# (is the below comment relevant anymore?)
		## dodoc does not supportly support directory traversal, #15193
		docinto examples
		dodoc -r sample contrib
	fi

	# https://bugs.gentoo.org/755680#c3
	doman doc/openvpn.8

	# https://github.com/OpenVPN/openvpn/issues/482 (bug #857648)
	newtmpfiles distro/systemd/tmpfiles-openvpn.conf openvpn.conf
}

pkg_postinst() {
	tmpfiles_process openvpn.conf

	if systemd_is_booted || has_version sys-apps/systemd ; then
		elog "In order to use OpenVPN with systemd please use the correct systemd service file."
		elog
		elog "server:"
		elog
		elog "- Place your server configuration file in /etc/openvpn/server"
		elog "- Use the openvpn-server@.service like so"
		elog "systemctl start openvpn-server@{Server-config}"
		elog
		elog "client:"
		elog
		elog "- Place your client configuration file in /etc/openvpn/client"
		elog "- Use the openvpn-client@.service like so:"
		elog "systemctl start openvpn-client@{Client-config}"
	else
		elog "The openvpn init script expects to find the configuration file"
		elog "openvpn.conf in /etc/openvpn along with any extra files it may need."
		elog
		elog "To create more VPNs, simply create a new .conf file for it and"
		elog "then create a symlink to the openvpn init script from a link called"
		elog "openvpn.newconfname - like so"
		elog "	 cd /etc/openvpn"
		elog "	 ${EDITOR##*/} foo.conf"
		elog "	 cd /etc/init.d"
		elog "	 ln -s openvpn openvpn.foo"
		elog
		elog "You can then treat openvpn.foo as any other service, so you can"
		elog "stop one vpn and start another if you need to."
	fi

	if grep -Eq "^[ \t]*(up|down)[ \t].*" "${ROOT}/etc/openvpn"/*.conf 2>/dev/null ; then
		ewarn
		ewarn "WARNING: If you use the remote keyword then you are deemed to be"
		ewarn "a client by our init script and as such we force up,down scripts."
		ewarn "These scripts call /etc/openvpn/\$SVCNAME-{up,down}.sh where you"
		ewarn "can move your scripts to."
	fi

	if use plugins ; then
		einfo
		einfo "plugins have been installed into /usr/$(get_libdir)/${PN}/plugins"
	fi
}
