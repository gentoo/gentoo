# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit bash-completion-r1 check-reqs cmake db-use desktop edo multiprocessing python-any-r1 systemd toolchain-funcs xdg-utils

DESCRIPTION="Reference implementation of the Bitcoin cryptocurrency"
HOMEPAGE="https://bitcoincore.org/"
SRC_URI="
	https://github.com/bitcoin/bitcoin/archive/v${PV/_rc/rc}.tar.gz -> ${P}.tar.gz
	https://github.com/bitcoin/bitcoin/commit/6d4214925fadc36d26aa58903db5788c742e68c6.patch?full_index=1 -> ${PN}-29.0-qt6.patch
"
S="${WORKDIR}/${PN/-core}-${PV/_rc/rc}"

LICENSE="MIT"
SLOT="0"
if [[ "${PV}" != *_rc* ]] ; then
	KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi
IUSE="asm +berkdb +cli +daemon dbus examples +external-signer gui qrcode +sqlite +system-libsecp256k1 systemtap test test-full zeromq"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	dbus? ( gui )
	qrcode? ( gui )
	test-full? ( test )
"
# dev-libs/univalue is now bundled, as upstream dropped support for system copy
# and their version in the Bitcoin repo has deviated a fair bit from upstream.
# Upstream also seems very inactive.
COMMON_DEPEND="
	>=dev-libs/boost-1.81.0:=
	>=dev-libs/libevent-2.1.12:=
	berkdb? ( >=sys-libs/db-4.8.30:$(db_ver_to_slot 4.8)=[cxx] )
	daemon? (
		acct-group/bitcoin
		acct-user/bitcoin
	)
	gui? (
		>=dev-qt/qtbase-6.2:6[dbus?,gui,network,widgets]
	)
	qrcode? ( >=media-gfx/qrencode-4.1.1:= )
	sqlite? ( >=dev-db/sqlite-3.38.5:= )
	system-libsecp256k1? ( >=dev-libs/libsecp256k1-0.6.0:=[asm=,ellswift,extrakeys,recovery,schnorr] )
	zeromq? ( >=net-libs/zeromq-4.3.4:= )
"
RDEPEND="
	${COMMON_DEPEND}
	!dev-util/bitcoin-tx
	cli? ( !net-p2p/bitcoin-cli )
	daemon? ( !net-p2p/bitcoind )
	gui? ( !net-p2p/bitcoin-qt )
"
DEPEND="
	${COMMON_DEPEND}
	systemtap? ( >=dev-debug/systemtap-4.8 )
"
BDEPEND="
	>=dev-build/cmake-3.25
	virtual/pkgconfig
	daemon? (
		acct-group/bitcoin
		acct-user/bitcoin
	)
	gui? ( >=dev-qt/qttools-6.2:6[linguist] )
	test? (
		${PYTHON_DEPS}
	)
"
IDEPEND="
	gui? ( dev-util/desktop-file-utils )
"

DOCS=(
	doc/bips.md
	doc/bitcoin-conf.md
	doc/descriptors.md
	doc/files.md
	doc/i2p.md
	doc/JSON-RPC-interface.md
	doc/multisig-tutorial.md
	doc/p2p-bad-ports.md
	doc/psbt.md
	doc/reduce-memory.md
	doc/reduce-traffic.md
	doc/release-notes.md
	doc/REST-interface.md
	doc/tor.md
)

PATCHES=(
	"${DISTDIR}/${PN}-29.0-qt6.patch"
	"${FILESDIR}/29.0-cmake-syslibs.patch"
	"${FILESDIR}/26.0-init.patch"
)

efmt() {
	: ${1:?} ; local l ; while read -r l ; do "${!#}" "${l}" ; done < <(fmt "${@:1:$#-1}")
}

pkg_pretend() {
	if ! use daemon && ! use gui && ! has_version "${CATEGORY}/${PN}[-daemon,-gui(-),-qt5(-)]" ; then
		efmt ewarn <<-EOF
			You are enabling neither USE="daemon" nor USE="gui". This is a valid
			configuration, but you will be unable to run a Bitcoin node using this
			installation.
		EOF
	fi
	if use daemon && ! use cli && ! has_version "${CATEGORY}/${PN}[daemon,-bitcoin-cli(-),-cli(-)]" ; then
		efmt ewarn <<-EOF
			You are enabling USE="daemon" but not USE="cli". This is a valid
			configuration, but you will be unable to interact with your bitcoind node
			via the command line using this installation.
		EOF
	fi
	if ! use berkdb && ! use sqlite &&
		{ { use daemon && ! has_version "${CATEGORY}/${PN}[daemon,-berkdb,-sqlite]" ; } ||
		  { use gui && ! has_version "${CATEGORY}/${PN}[gui,-berkdb,-sqlite]" ; } ; }
	then
		efmt ewarn <<-EOF
			You are enabling neither USE="berkdb" nor USE="sqlite". This is a valid
			configuration, but your Bitcoin node will be unable to open any wallets.
		EOF
	fi

	# test/functional/feature_pruning.py requires 4 GB disk space
	# test/functional/wallet_pruning.py requires 1.3 GB disk space
	use test && CHECKREQS_DISK_BUILD="6G" check-reqs_pkg_pretend
}

pkg_setup() {
	if use test ; then
		CHECKREQS_DISK_BUILD="6G" check-reqs_pkg_setup
		python-any-r1_pkg_setup
	fi

	# check for auto-loaded wallets in the obsolete (soon to be unsupported) format
	if use daemon && use berkdb && [[ -r "${EROOT}/var/lib/bitcoind/settings.json" ]] ; then
		local wallet bdb_wallets=()
		while read -rd '' wallet ; do
			# printf interprets any C-style escape sequences in ${wallet}
			wallet="${EROOT}$(printf "/var/lib/bitcoind/wallets/${wallet:+${wallet//\%/%%}/}wallet.dat")"
			[[ -r "${wallet}" && "$(file -b -- "${wallet}")" == *'Berkeley DB'* ]] && bdb_wallets+=( "${wallet}" )
		done < <(
			# parsing settings.json using jq would be far cleaner, but jq might not be installed
			sed -Enze 'H;${x;s/^.*"wallet"\s*:\s*\[\s*("([^"\\]|\\.)*"(\s*,\s*"([^"\\]|\\.)*")*)\s*\].*$/\1/;T' \
					-e 's/"(([^"\\]|\\.)*)"\s*(,\s*)?/\1\x0/gp}' -- "${EROOT}/var/lib/bitcoind/settings.json"
		)
		if (( ${#bdb_wallets[@]} )) ; then
			efmt -su ewarn <<-EOF
				The following auto-loaded wallets are in the legacy (Berkeley DB) format, \
				which will no longer be supported by the next major version of Bitcoin Core:
				$(printf ' - %s\n' "${bdb_wallets[@]}")
			EOF
			use cli && efmt ewarn <<-EOF
				You may want to convert them to descriptor wallets by executing
				\`bitcoin-cli migratewallet "<wallet_name>" ["<passphrase>"]\`
				after starting bitcoind.
			EOF
		fi
	fi
}

src_prepare() {
	# https://bugs.gentoo.org/958361
	# https://github.com/google/crc32c/commit/2bbb3be42e20a0e6c0f7b39dc07dc863d9ffbc07
	sed -e '/^cmake_minimum_required(VERSION 3\.1)$/s/)$/6)/' -i src/crc32c/CMakeLists.txt || die

	eapply_user
	! use system-libsecp256k1 || rm -r src/secp256k1 || die
	cmake_src_prepare

	# we set BUILD_UTIL=OFF, so we can't test bitcoin-util
	sed -ne '/^  {/{h;:0;n;H;/^  }/!b0;g;\|"exec": *"\./bitcoin-util"|d};p' \
		-i test/util/data/bitcoin-util-test.json || die

	sed -e 's/^\(complete -F _bitcoind\b\).*$/\1'"$(usev daemon ' bitcoind')$(usev gui ' bitcoin-qt')/" \
		-i contrib/completions/bash/bitcoind.bash || die
}

src_configure() {
	local wallet ; if use berkdb || use sqlite ; then wallet=ON ; else wallet=OFF ; fi
	local mycmakeargs=(
#		-DCMAKE_DISABLE_FIND_PACKAGE_Git=ON	# https://github.com/bitcoin/bitcoin/pull/32220
		-DBUILD_SHARED_LIBS=ON
		-DENABLE_WALLET=${wallet}
		-DWITH_SQLITE=$(usex sqlite)
		-DWITH_BDB=$(usex berkdb)
		-DWITH_USDT=$(usex systemtap)
		-DBUILD_TESTS=$(usex test)
		-DBUILD_BENCH=OFF
		-DBUILD_{FOR_FUZZING,FUZZ_BINARY}=OFF
		-DWITH_QRENCODE=$(usex qrcode)
		-DWITH_CCACHE=OFF
		-DWITH_ZMQ=$(usex zeromq)
		-DENABLE_EXTERNAL_SIGNER=$(usex external-signer)
		-DBUILD_CLI=$(usex cli)
		-DBUILD_TX=ON
		-DBUILD_WALLET_TOOL=${wallet}
		-DBUILD_UTIL=OFF
		-DBUILD_DAEMON=$(usex daemon)
		-DBUILD_GUI=$(usex gui)
		-DWITH_DBUS=$(usex dbus)
		-DWITH_SYSTEM_LIBSECP256K1=$(usex system-libsecp256k1 ON \
			"OFF -DSECP256K1_ASM=$(usex asm AUTO OFF)")
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use daemon && ! tc-is-cross-compiler ; then
		TOPDIR="${S}" BUILDDIR="${BUILD_DIR}" bash contrib/devtools/gen-bitcoin-conf.sh || die
	fi
	sed -e 's/ To use, copy this file$//p;Tp;:0;n;/save the file\.$/!b0;d;:p;p' \
		-ni share/examples/bitcoin.conf || die
}

src_test() {
	cmake_src_test

	if use daemon ; then
		cd -- "${BUILD_DIR}" || die
		edo "${PYTHON}" test/functional/test_runner.py \
			--ansi $(usev test-full --extended) --jobs="$(get_makeopts_jobs)" --timeout-factor="${TIMEOUT_FACTOR:-15}"
	fi
}

src_install() {
	dodoc -r doc/release-notes

	use external-signer && DOCS+=( doc/external-signer.md )
	use berkdb || use sqlite && DOCS+=( doc/managing-wallets.md )
	use systemtap && DOCS+=( doc/tracing.md )
	use zeromq && DOCS+=( doc/zmq.md )

	if use daemon ; then
		# https://bugs.gentoo.org/757102
		DOCS+=( share/rpcauth/rpcauth.py )
		docompress -x "/usr/share/doc/${PF}/rpcauth.py"
	fi

	einstalldocs
	cmake_src_install

	find "${ED}" -type f -name '*.la' -delete || die
	! use test || rm -f -- "${ED}"/usr/bin/test_bitcoin{,-qt} || die

	newbashcomp contrib/completions/bash/bitcoin-tx.bash bitcoin-tx
	use cli && newbashcomp contrib/completions/bash/bitcoin-cli.bash bitcoin-cli
	if use daemon ; then
		newbashcomp contrib/completions/bash/bitcoind.bash bitcoind
		use gui && bashcomp_alias bitcoind bitcoin-qt
	elif use gui ; then
		newbashcomp contrib/completions/bash/bitcoind.bash bitcoin-qt
	fi

	if use daemon ; then
		insinto /etc/bitcoin
		doins share/examples/bitcoin.conf
		fowners bitcoin:bitcoin /etc/bitcoin/bitcoin.conf
		fperms 0660 /etc/bitcoin/bitcoin.conf

		newconfd contrib/init/bitcoind.openrcconf bitcoind
		newinitd "${FILESDIR}/bitcoind.openrc" bitcoind
		systemd_newunit contrib/init/bitcoind.service bitcoind.service

		keepdir /var/lib/bitcoind
		fperms 0750 /var/lib/bitcoind
		fowners bitcoin:bitcoin /var/lib/bitcoind
		dosym -r {/etc/bitcoin,/var/lib/bitcoind}/bitcoin.conf

		insinto /etc/logrotate.d
		newins "${FILESDIR}/bitcoind.logrotate-r1" bitcoind
	fi

	if use gui ; then
		insinto /usr/share/icons/hicolor/scalable/apps
		newins src/qt/res/src/bitcoin.svg bitcoin128.svg

		domenu "${FILESDIR}/org.bitcoin.bitcoin-qt.desktop"
	fi

	if use examples ; then
		docinto examples
		dodoc -r contrib/{linearize,qos}
		use zeromq && dodoc -r contrib/zmq
	fi
}

pkg_postinst() {
	# we don't use xdg.eclass because it adds unconditional IDEPENDs
	if use gui ; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi

	if use daemon && [[ -z "${REPLACING_VERSIONS}" ]] ; then
		efmt -su elog <<-EOF
			To have ${PN} automatically use Tor when it's running, be sure your \
			'torrc' config file has 'ControlPort' and 'CookieAuthentication' set up \
			correctly, and:
			- Using an init script: add the 'bitcoin' user to the 'tor' user group.
			- Running bitcoind directly: add that user to the 'tor' user group.
			EOF
	fi

	if use cli && use daemon ; then
		efmt -su elog <<-EOF
			To use bitcoin-cli with the /etc/init.d/bitcoind service:
			 - Add your user(s) to the 'bitcoin' group.
			 - Symlink ~/.bitcoin to /var/lib/bitcoind.
		EOF
	fi

	if use berkdb ; then
		# https://github.com/bitcoin/bitcoin/pull/28597
		# https://bitcoincore.org/en/releases/26.0/#wallet
		efmt ewarn <<-EOF
			Creation of legacy (Berkeley DB) wallets is refused starting with Bitcoin
			Core 26.0, pending the deprecation and eventual removal of support for
			legacy wallets altogether in future releases. At present you can still
			force support for the creation of legacy wallets by adding the following
			line to your bitcoin.conf:

			deprecatedrpc=create_bdb
		EOF
	fi
}

pkg_postrm() {
	if use gui ; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
