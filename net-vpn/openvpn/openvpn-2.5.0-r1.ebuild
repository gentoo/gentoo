# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic systemd linux-info

DESCRIPTION="Robust and highly flexible tunneling application compatible with many OSes"
SRC_URI="https://build.openvpn.net/downloads/releases/${P}.tar.gz -> ${P}-r1.tar.gz"
HOMEPAGE="https://openvpn.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"

IUSE="down-root examples inotify iproute2 libressl lz4 +lzo mbedtls +openssl"
IUSE+=" pam pkcs11 +plugins selinux systemd test userland_BSD"

RESTRICT="!test? ( test )"
REQUIRED_USE="
	^^ ( openssl libressl mbedtls )
	pkcs11? ( !mbedtls )
	!plugins? ( !pam !down-root )
	inotify? ( plugins )
"

CDEPEND="
	kernel_linux? (
		iproute2? ( sys-apps/iproute2[-minimal] )
	)
	libressl? ( dev-libs/libressl:0= )
	lz4? ( app-arch/lz4 )
	lzo? ( >=dev-libs/lzo-1.07 )
	mbedtls? ( net-libs/mbedtls:= )
	openssl? ( >=dev-libs/openssl-0.9.8:0= )
	pam? ( sys-libs/pam )
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

PATCHES=(
	"${FILESDIR}/openvpn-2.5.0-auth-pam-missing-header.patch"
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

	if use libressl || ! use mbedtls; then
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
	)
	SYSTEMD_UNIT_DIR=$(systemd_get_systemunitdir) \
		TMPFILES_DIR="/usr/lib/tmpfiles.d" \
		IPROUTE=$(usex iproute2 '/bin/ip' '') \
		econf "${myeconfargs[@]}"
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
		docinto /usr/share/doc/${PF}/examples
		dodoc -r sample contrib
	fi

	# https://bugs.gentoo.org/755680#c3
	doman doc/openvpn.8
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
}
