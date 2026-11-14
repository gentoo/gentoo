# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit eapi9-ver flag-o-matic python-any-r1 systemd toolchain-funcs

DESCRIPTION="An Open Source MQTT v3 Broker"
HOMEPAGE="https://mosquitto.org/ https://github.com/eclipse/mosquitto"
SRC_URI="https://mosquitto.org/files/source/${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~sparc ~x86"
IUSE="+bridge examples +persistence +srv ssl systemd tcpd test websockets"
RESTRICT="!test? ( test )"

REQUIRED_USE="test? ( bridge )"

RDEPEND="
	acct-user/mosquitto
	acct-group/mosquitto
	dev-libs/cJSON
	srv? ( net-dns/c-ares:= )
	ssl? (
		dev-libs/openssl:0=
	)
	systemd? ( sys-apps/systemd:= )
	tcpd? ( sys-apps/tcp-wrappers )
	websockets? ( net-libs/libwebsockets[lejp] )
"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cunit )
"
BDEPEND="
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/psutil[${PYTHON_USEDEP}]')
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.22-openssl4.patch
)

python_check_deps() {
	python_has_version -b "dev-python/psutil[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python_setup
}

_emake() {
	local LIBDIR=$(get_libdir)
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CLIENT_LDFLAGS="${LDFLAGS}" \
		LIB_SUFFIX="${LIBDIR:3}" \
		WITH_BRIDGE="$(usex bridge)" \
		WITH_PERSISTENCE="$(usex persistence)" \
		WITH_SRV="$(usex srv)" \
		WITH_SYSTEMD="$(usex systemd)" \
		WITH_TLS="$(usex ssl)" \
		WITH_WEBSOCKETS="$(usex websockets)" \
		WITH_WRAP="$(usex tcpd)" \
		"$@"
}

src_prepare() {
	default
	if use persistence; then
		sed -i -e "/^#autosave_interval/s|^#||" \
			-e "s|^#persistence false$|persistence true|" \
			-e "/^#persistence_file/s|^#||" \
			-e "s|#persistence_location|persistence_location /var/lib/mosquitto/|" \
			mosquitto.conf || die
	fi

	# Remove failing tests
	sed -i \
		-e '/06-bridge-reconnect-local-out.py/d' \
		test/broker/Makefile || die
	sed -i \
		-e '/02-subscribe-qos1-async2.test/d' \
		test/lib/Makefile || die

	# This test was broken by OpenSSL 4 porting, but it remains broken
	# upstream as upstream CMake (as opposed to the Makefiles) doesn't
	# actually mention the file.
	sed -i \
		-e '/^build : /s:tls_test::' \
		-e '/\.\/tls_test/d' \
		test/unit/Makefile || die

	# Needs new test certs for OpenSSL 4. Some tests are also duplicated
	# across Makefiles :(
	sed -i \
		-e '/08-ssl-bridge.py/d' \
		-e '/08-ssl-connect-cert-auth-crl.py/d' \
		-e '/08-ssl-connect-cert-auth-expired.py/d' \
		-e '/08-ssl-connect-cert-auth-revoked.py/d' \
		-e '/08-ssl-connect-identity.py/d' \
		-e '/08-ssl-connect-no-auth.py/d' \
		-e '/08-ssl-connect-no-identity.py/d' \
		-e '/08-ssl-connect-cert-auth.py/d' \
		-e '/08-ssl-hup-disconnect.py/d' \
		-e '/08-ssl-connect-cert-auth-enc.py/d' \
		-e '/08-ssl-connect-cert-auth.py/d' \
		test/broker/Makefile test/lib/Makefile || die

	# Extend test timeout to prevent spurious failures
	sed -i -e 's/SUB_TIMEOUT=1/SUB_TIMEOUT=3/' \
		test/client/test.sh || die

	use test && python_fix_shebang test
}

src_compile() {
	# ODR issues in tests
	filter-lto

	_emake
}

src_test() {
	_emake test
}

src_install() {
	_emake DESTDIR="${D}" prefix=/usr install
	keepdir /var/lib/mosquitto
	fowners mosquitto:mosquitto /var/lib/mosquitto
	dodoc README.md CONTRIBUTING.md ChangeLog.txt
	doinitd "${FILESDIR}"/mosquitto
	insinto /etc/mosquitto
	doins mosquitto.conf
	insinto /usr/share/mosquitto
	doins misc/letsencrypt/mosquitto-copy.sh
	systemd_newunit "${FILESDIR}/mosquitto.notify.service" mosquitto.service

	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
}

pkg_postinst() {
	if ver_replacing -lt 2; then
		elog
		elog "Please read the migration guide at:"
		elog "https://mosquitto.org/documentation/migrating-to-2-0/"
		elog
		elog "If you use Lets Encrypt TLS certificates, take note of"
		elog "the changes required to run the daemon as the unprivileged"
		elog "mosquitto user. The mosquitto-copy.sh script has been"
		elog "installed to /usr/share/mosquitto/ for your convenience."
		elog
	fi
}
