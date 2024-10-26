# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit autotools bash-completion-r1 check-reqs db-use desktop edo multiprocessing python-any-r1 systemd toolchain-funcs xdg-utils

DESCRIPTION="Reference implementation of the Bitcoin cryptocurrency"
HOMEPAGE="https://bitcoincore.org/"
SRC_URI="
	https://github.com/bitcoin/bitcoin/archive/v${PV/_rc/rc}.tar.gz -> ${P}.tar.gz
	https://github.com/bitcoin/bitcoin/commit/8acdf66540834b9f9cf28f16d389e8b6a48516d5.patch?full_index=1 -> ${PN}-miniupnpc-2.2.8-compat.patch
"
S="${WORKDIR}/${PN/-core}-${PV/_rc/rc}"

LICENSE="MIT"
SLOT="0"
if [[ "${PV}" != *_rc* ]] ; then
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
fi
IUSE="+asm +berkdb +cli +daemon dbus examples +external-signer gui kde libs +man nat-pmp +qrcode +sqlite system-leveldb +system-libsecp256k1 systemtap test upnp zeromq"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	dbus? ( gui )
	kde? ( gui )
	qrcode? ( gui )
	system-leveldb? ( || ( daemon gui ) )
"
# dev-libs/univalue is now bundled, as upstream dropped support for system copy
# and their version in the Bitcoin repo has deviated a fair bit from upstream.
# Upstream also seems very inactive.
RDEPEND="
	!dev-util/bitcoin-tx
	>=dev-libs/boost-1.81.0:=
	>=dev-libs/libevent-2.1.12:=
	berkdb? ( >=sys-libs/db-4.8.30:$(db_ver_to_slot 4.8)=[cxx] )
	cli? ( !net-p2p/bitcoin-cli )
	daemon? (
		!net-p2p/bitcoind
		acct-group/bitcoin
		acct-user/bitcoin
	)
	gui? (
		!net-p2p/bitcoin-qt
		>=dev-qt/qtcore-5.15.11:5
		>=dev-qt/qtgui-5.15.11:5
		>=dev-qt/qtnetwork-5.15.11:5
		>=dev-qt/qtwidgets-5.15.11:5
		dbus? ( >=dev-qt/qtdbus-5.15.11:5 )
	)
	libs? ( !net-libs/libbitcoinconsensus )
	nat-pmp? ( >=net-libs/libnatpmp-20220705:= )
	qrcode? ( >=media-gfx/qrencode-4.1.1:= )
	sqlite? ( >=dev-db/sqlite-3.38.5:= )
	system-leveldb? ( virtual/bitcoin-leveldb )
	system-libsecp256k1? ( >=dev-libs/libsecp256k1-0.4.0:=[ellswift,extrakeys,recovery,schnorr] )
	upnp? ( >=net-libs/miniupnpc-2.2.2:= )
	zeromq? ( >=net-libs/zeromq-4.3.4:= )
"
DEPEND="
	${RDEPEND}
	systemtap? ( >=dev-debug/systemtap-4.8 )
"
BDEPEND="
	virtual/pkgconfig
	daemon? (
		acct-group/bitcoin
		acct-user/bitcoin
	)
	gui? ( >=dev-qt/linguist-tools-5.15.11:5 )
	test? ( ${PYTHON_DEPS} )
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
	"${DISTDIR}/${PN}-miniupnpc-2.2.8-compat.patch"
	"${FILESDIR}/25.0-gcc15.patch"
	"${FILESDIR}/27.0-gcc15.patch"
	"${FILESDIR}/27.0-syslibs.patch"
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
}

src_prepare() {
	default
	! use system-leveldb || rm -r src/leveldb || die
	if use system-libsecp256k1 ; then
		rm -r src/secp256k1 || die
		sed -e '/^DIST_SUBDIRS *=/s/\bsecp256k1\b//' -i src/Makefile.am || die
	else
		pushd src/secp256k1 >/dev/null || die
		AT_NOELIBTOOLIZE=yes eautoreconf
		popd >/dev/null || die
	fi
	eautoreconf

	# we say --disable-util-util, so we can't test bitcoin-util
	sed -ne '/^  {/{h;:0;n;H;/^  }/!b0;g;\|"exec": *"\./bitcoin-util"|d};p' \
		-i test/util/data/bitcoin-util-test.json || die

	sed -e 's/^\(complete -F _bitcoind\b\).*$/\1'"$(usev daemon ' bitcoind')$(usev gui ' bitcoin-qt')/" \
		-i contrib/completions/bash/bitcoind.bash || die
}

src_configure() {
	local wallet ; if use berkdb || use sqlite ; then wallet=enable ; else wallet=disable ; fi
	local myeconfargs=(
		--disable-static
		--${wallet}-wallet
		$(use_with sqlite)
		$(use_with berkdb bdb)
		$(use_enable systemtap usdt)
		$(use_with upnp miniupnpc)
		$(use_with nat-pmp natpmp)
		$(use_enable test tests)
		--disable-bench
		--disable-fuzz{,-binary}
		$(use_with qrcode qrencode)
		--disable-ccache
		$(use_enable asm)
		$(use_enable zeromq zmq)
		$(use_enable man)
		$(use_enable external-signer)
		--with-utils
		$(use_enable {,util-}cli)
		--enable-util-tx
		--${wallet}-util-wallet
		--disable-util-util
		$(use_with libs)
		$(use_with daemon)
		$(use_with gui gui qt5)
		$(use_with dbus qtdbus)
		$(use_with system-leveldb)
		$(use_with system-libsecp256k1)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	if use daemon && ! tc-is-cross-compiler ; then
		TOPDIR="${S}" bash contrib/devtools/gen-bitcoin-conf.sh || die
	fi
	sed -e 's/ To use, copy this file$//p;Tp;:0;n;/save the file\.$/!b0;d;:p;p' \
		-ni share/examples/bitcoin.conf || die
}

src_test() {
	emake check

	use daemon && edo "${PYTHON}" test/functional/test_runner.py \
			--ansi --extended --jobs="$(get_makeopts_jobs)" --timeout-factor="${TIMEOUT_FACTOR:-15}"
}

src_install() {
	use external-signer && DOCS+=( doc/external-signer.md )
	use berkdb || use sqlite && DOCS+=( doc/managing-wallets.md )
	use libs && DOCS+=( doc/shared-libraries.md )
	use systemtap && DOCS+=( doc/tracing.md )
	use zeromq && DOCS+=( doc/zmq.md )

	if use daemon ; then
		# https://bugs.gentoo.org/757102
		DOCS+=( share/rpcauth/rpcauth.py )
		docompress -x "/usr/share/doc/${PF}/rpcauth.py"
	fi

	default

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

		if use kde ; then
			insinto /usr/share/kservices5
			doins "${FILESDIR}/bitcoin-qt.protocol"
		fi
	fi

	if use examples ; then
		docinto examples
		dodoc -r contrib/{linearize,qos}
		use zeromq && dodoc -r contrib/zmq
	fi
}

pkg_preinst() {
	if use daemon && [[ -d "${EROOT}/var/lib/bitcoin/.bitcoin" ]] ; then
		if [[ -h "${EROOT}/var/lib/bitcoin/.bitcoin" ]] ; then
			dosym -r /var/lib/bitcoin{d,/.bitcoin}
		elif [[ ! -e "${EROOT}/var/lib/bitcoind" || -h "${EROOT}/var/lib/bitcoind" ]] ; then
			efmt ewarn <<-EOF
				Your bitcoind data directory is located at ${EPREFIX}/var/lib/bitcoin/.bitcoin,
				a deprecated location. To perform an automated migration to
				${EPREFIX}/var/lib/bitcoind, first shut down any running bitcoind instances
				that may be using the deprecated path, and then run:

				# emerge --config ${CATEGORY}/${PN}
				EOF
			insinto /var/lib/bitcoin
			mv -- "${ED}/var/lib/bitcoin"{d,/.bitcoin} || die
			dosym -r {/etc/,/var/lib/bitcoin/.}bitcoin/bitcoin.conf
			dosym -r /var/lib/bitcoin{/.bitcoin,d}
		fi
	fi

	if use kde && [[ -d "${EROOT}/usr/share/kde4" ]] ; then
		dosym -r /usr/share/{kservices5,kde4/services}/bitcoin-qt.protocol
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

pkg_config() {
	if [[ -d "${EROOT}/var/lib/bitcoin/.bitcoin" && ! -h "${EROOT}/var/lib/bitcoin/.bitcoin" ]] &&
		[[ ! -e "${EROOT}/var/lib/bitcoind" || -h "${EROOT}/var/lib/bitcoind" ]]
	then
		in_use() {
			: ${1:?} ; local each
			if command -v fuser >/dev/null ; then
				fuser "${@}" >/dev/null 2>&1
			elif command -v lsof >/dev/null ; then
				for each ; do
					lsof -- "${each}" && return
				done >/dev/null 2>&1
			elif mountpoint -q /proc ; then
				{ find /proc/[0-9]*/{cwd,exe,fd} -type l -exec readlink -- {} +
					awk '{ print $6 }' /proc/[0-9]*/maps
				} 2>/dev/null | grep -Fqx -f <(printf '%s\n' "${@}" ; readlink -m -- "${@}")
			else
				return 13
			fi
		}
		ebegin "Checking that ${EPREFIX}/var/lib/bitcoin/.bitcoin is not in use"
		in_use "${EROOT}/var/lib/bitcoin/.bitcoin"{,/.lock}
		case $? in
			0)
				eend 1
				efmt eerror <<-EOF
					${EPREFIX}/var/lib/bitcoin/.bitcoin is currently in use. Please stop any
					running bitcoind instances that may be using this data directory, and then
					retry this migration.
					EOF
				die "${EPREFIX}/var/lib/bitcoin/.bitcoin is in use"
				;;
			13)
				eend 1
				if [[ "${BITCOIND_IS_NOT_RUNNING}" != 1 ]] ; then
					efmt eerror <<-EOF
						Found no way to check whether ${EPREFIX}/var/lib/bitcoin/.bitcoin is in use.
						Do you have /proc mounted? To force the migration without checking, re-run
						this command with BITCOIND_IS_NOT_RUNNING=1.
						EOF
					die "could not check whether ${EPREFIX}/var/lib/bitcoin/.bitcoin is in use"
				fi
				;;
			*)
				eend 0
				;;
		esac

		# find all relative symlinks that point outside the data dir
		local -A symlinks
		cd -- "${EROOT}/var/lib/bitcoin/.bitcoin" || die
		local each ; while read -r -d '' each ; do
			local target=$(readlink -- "${each}") && [[ "${target}" == ../* ]] &&
				target=$(readlink -e -- "${each}") && [[ "${target}" != "${EROOT}/var/lib/bitcoin/.bitcoin/"* ]] &&
				symlinks["${each}"]="${target}"
		done < <(find -type l -print0)

		einfo "Moving your ${EPREFIX}/var/lib/bitcoin/.bitcoin to ${EPREFIX}/var/lib/bitcoind."
		rm -f -- "${EROOT}/var/lib/bitcoind" || die
		mv --no-clobber --no-copy --no-target-directory -- "${EROOT}/var/lib/bitcoin"{/.bitcoin,d} ||
			die "Failed to move your ${EPREFIX}/var/lib/bitcoin/.bitcoin to ${EPREFIX}/var/lib/bitcoind."

		# fix up the relative symlinks
		cd -- "${EROOT}/var/lib/bitcoind" || die
		for each in "${!symlinks[@]}" ; do
			ln -fnrs -- "${symlinks[${each}]}" "${each}"  # keep going even if this fails
		done

		einfo 'Creating a transitional symlink for your convenience.'
		ln -fnrsv -- "${EROOT}/var/lib/bitcoin"{d,/.bitcoin}
		einfo 'You may remove this link when you no longer need it.'
	else
		einfo 'Nothing to do.'
	fi
}
