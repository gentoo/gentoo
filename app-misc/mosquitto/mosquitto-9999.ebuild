# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{12..15} )

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/eclipse-mosquitto/mosquitto.git"
	inherit git-r3
	# Release tarballs ship prebuilt man pages, git does not
	BDEPEND="app-text/docbook-xsl-stylesheets"
else
	SRC_URI="https://mosquitto.org/files/source/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~sparc ~x86"
fi

inherit cmake eapi9-ver python-any-r1 systemd

DESCRIPTION="An Open Source MQTT Broker"
HOMEPAGE="https://mosquitto.org/ https://github.com/eclipse-mosquitto/mosquitto"

LICENSE="EPL-1.0"
SLOT="0"
IUSE="+bridge examples +persistence +srv ssl systemd tcpd test websockets"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	test? ( bridge )
	websockets? ( ssl )
"

RDEPEND="
	acct-user/mosquitto
	acct-group/mosquitto
	dev-libs/cJSON
	persistence? ( dev-db/sqlite:3 )
	srv? ( net-dns/c-ares:= )
	ssl? (
		dev-libs/openssl:0=
	)
	systemd? ( sys-apps/systemd:= )
	tcpd? ( sys-apps/tcp-wrappers )
"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/gtest
		dev-util/cunit
	)
"
BDEPEND+="
	dev-libs/libxslt
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/psutil[${PYTHON_USEDEP}]')
	)
"

python_check_deps() {
	python_has_version -b "dev-python/psutil[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python_setup
}

src_prepare() {
	cmake_src_prepare

	if use persistence; then
		sed -i -e "/^#autosave_interval/s|^#||" \
			-e "s|^#persistence false$|persistence true|" \
			-e "/^#persistence_file/s|^#||" \
			-e "s|#persistence_location|persistence_location /var/lib/mosquitto/|" \
			mosquitto.conf || die
	fi

	# "mosquitto_signal -a" sends SIGHUP to every mosquitto process on the
	# system, reloading the brokers of tests running in parallel (and any
	# broker running on the host).
	# https://github.com/eclipse-mosquitto/mosquitto/pull/3823
	sed -i -e '/do_test(\["-a", "config-reload"\], 0)/d' \
		test/apps/signal/signal-args.py || die

	# Extend test timeout to prevent spurious failures
	sed -i -e 's/timeout=1,/timeout=3,/' \
		test/apps/db_dump/*.py || die

	use test && python_fix_shebang test
}

src_configure() {
	# Options are exported to the test environment, and the tests compare
	# them against the literal string "ON", so do not use yes/no.
	# https://github.com/eclipse-mosquitto/mosquitto/pull/3825
	local mycmakeargs=(
		# argon2 support is compiled out, but the library is still linked
		-DCMAKE_DISABLE_FIND_PACKAGE_argon2=ON
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}"/etc
		-DINC_BRIDGE_SUPPORT="$(usex bridge ON OFF)"
		-DUSE_LIBWRAP="$(usex tcpd ON OFF)"
		-DWITH_CTRL_SHELL=OFF
		-DWITH_HTTP_API=OFF
		-DWITH_LTO=OFF
		-DWITH_PERSISTENCE="$(usex persistence ON OFF)"
		-DWITH_PLUGIN_PERSIST_SQLITE="$(usex persistence ON OFF)"
		-DWITH_SRV="$(usex srv ON OFF)"
		-DWITH_STATIC_LIBRARIES=OFF
		-DWITH_SYSTEMD="$(usex systemd ON OFF)"
		-DWITH_TESTS="$(usex test ON OFF)"
		-DWITH_TLS="$(usex ssl ON OFF)"
		-DWITH_WEBSOCKETS="$(usex websockets ON OFF)"
		-DWITH_WEBSOCKETS_BUILTIN=ON
	)
	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=()
	# The dynamic-security plugin is only built with TLS, and unlike the
	# other dynsec tests this one does not check for it.
	# https://github.com/eclipse-mosquitto/mosquitto/pull/3824
	use ssl || CMAKE_SKIP_TESTS+=( broker-14-dynsec-delete-role )

	# Tests that use network ports reserve them through ctest resource
	# groups. Some tests are timing sensitive, so retry failures as upstream
	# does in its own ctest configuration.
	cmake_src_test \
		--resource-spec-file "${S}"/test/resource.json \
		--repeat until-pass:5
}

src_install() {
	cmake_src_install
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
