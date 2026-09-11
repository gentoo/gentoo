# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo multiprocessing systemd tmpfiles toolchain-funcs

DESCRIPTION="Persistent key-value store, fork of dev-db/redis"
HOMEPAGE="https://valkey.io https://github.com/valkey-io/valkey"
SRC_URI="
	https://github.com/valkey-io/valkey/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
"

# deps/fast_float: || ( Apache-2.0 MIT Boost-1.0 )
# deps/fpconv: Boost-1.0
# deps/hdr_histogram: CC0-1.0
# deps/lua: MIT
LICENSE="BSD || ( Apache-2.0 MIT Boost-1.0 ) Boost-1.0 CC0-1.0 MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="jemalloc ssl systemd tcmalloc test"
RESTRICT="!test? ( test )"
REQUIRED_USE="?? ( jemalloc tcmalloc )"

DEPEND="
	jemalloc? ( >=dev-libs/jemalloc-5.1:=[stats] )
	ssl? ( dev-libs/openssl:= )
	systemd? ( sys-apps/systemd:= )
	tcmalloc? ( dev-util/google-perftools )
"
RDEPEND="
	${DEPEND}
	acct-group/valkey
	acct-user/valkey
"
BDEPEND="
	acct-group/valkey
	acct-user/valkey
	virtual/pkgconfig
	test? (
		dev-lang/tcl:0=
		ssl? ( dev-tcltk/tls )
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-9.1.0-config.patch
	"${FILESDIR}"/${PN}-9.1.0-config-sentinel.patch
	"${FILESDIR}"/${PN}-9.1.0-system-jemalloc.patch
	"${FILESDIR}"/${PN}-9.1.0-ppc-atomic.patch
	"${FILESDIR}"/${PN}-9.1.0-no-which.patch
)

src_prepare() {
	default

	# Respect user CFLAGS in bundled lua
	sed -i '/LUA_CFLAGS/s: -O2::g' deps/Makefile || die

	local mysedconf=(
		-e 's:-Werror ::g'
		-e 's:-Werror=deprecated-declarations ::g'
	)

	local f
	while IFS= read -r -d '' f; do
		sed -i "${mysedconf[@]}" "${f}" || die "sed failed for ${f}"
	done < <(find -name 'Makefile' -print0)

	# Linenoise can't be built with -std=c99, see bug #451164
	# also, don't define ANSI/c99 for lua twice
	sed -i -e "s:-std=c99::g" deps{,/linenoise}/Makefile || die
}

src_compile() {
	tc-export AR CC RANLIB

	# No point in unbundling Lua, as upstream have deviated too far from
	# vanilla Lua, adding their own APIs like lua_enablereadonlytable.
	local myconf=(
		AR="${AR}"
		CC="${CC}"
		RANLIB="${RANLIB}"

		V=1

		# OPTIMIZATION defaults to -O3. Let's respect user CFLAGS by setting it
		# to empty value.
		OPTIMIZATION=''
		# Disable debug flags in bundled libvalkey
		DEBUG=''
		DEBUG_FLAGS=''

		BUILD_TLS=$(usex ssl)
		USE_SYSTEMD=$(usex systemd)
	)

	if use jemalloc; then
		myconf+=( MALLOC=jemalloc )
	elif use tcmalloc; then
		myconf+=( MALLOC=tcmalloc )
	else
		myconf+=( MALLOC=libc )
	fi

	emake "${myconf[@]}"
}

src_test() {
	local runtestargs=(
		--verbose

		--clients "$(makeopts_jobs)" # bug #649868

		# The Active defrag for argv test fails with edge values, it does not seem to be
		# critical issue, see https://github.com/redis/redis/issues/14006
		--skiptest "/Active defrag for argv retained by the main thread from IO thread.*"

		# The following test fails with system jemalloc, as it expects
		# different values, because the bundled jemalloc is compiled with
		# --with-lg-quantum=3 parameter in order to provide additional size
		# classes which are not 16 byte alligned.
		--skiptest "Check MEMORY USAGE for embedded key strings with jemalloc"

		# Timing-sensitive, see https://github.com/valkey-io/valkey/issues/2482
		--skiptest "COPY Preserves TTLs"
		--skiptest "RESTORE Preserves Field TTLs"

		# Missing tmp in string
		--skiptest "Process title set as expected"

		# Unclear failure
		--tags -external:skip
	)

	if has usersandbox ${FEATURES} || ! has userpriv ${FEATURES}; then
		ewarn "oom-score-adj related tests will be skipped." \
			"They are known to fail with FEATURES usersandbox or -userpriv. See bug #756382."

		runtestargs+=(
			## unit/oom-score-adj was introduced in version 6.2.0
			--skipunit unit/oom-score-adj # bug #756382

			# Following test was added in version 7.0.0 to unit/introspection.
			# It also tries to adjust OOM score.
			--skiptest "CONFIG SET rollback on apply error"
		)
	fi

	# Breaks unrelated tests with 'large-memory' tag error (bug #976445)
	#if use ssl; then
	#	edo ./utils/gen-test-certs.sh
	#	runtestargs+=( --tls )
	#	:;
	#fi

	edo ./runtest "${runtestargs[@]}"
}

src_install() {
	insinto /etc/valkey
	doins valkey.conf sentinel.conf
	use prefix || fowners -R valkey:valkey /etc/valkey /etc/valkey/{valkey,sentinel}.conf
	fperms 0750 /etc/valkey
	fperms 0644 /etc/valkey/{valkey,sentinel}.conf

	newconfd "${FILESDIR}"/valkey.confd valkey
	newinitd "${FILESDIR}"/valkey.initd valkey

	systemd_newunit "${FILESDIR}"/valkey.service valkey.service
	newtmpfiles "${FILESDIR}"/valkey.tmpfiles valkey.conf

	newconfd "${FILESDIR}"/valkey-sentinel.confd valkey-sentinel
	newinitd "${FILESDIR}"/valkey-sentinel.initd valkey-sentinel

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	dodoc 00-RELEASENOTES CONTRIBUTING.md README.md

	dobin src/valkey-cli
	dosbin src/valkey-benchmark src/valkey-server src/valkey-check-aof src/valkey-check-rdb
	fperms 0750 /usr/sbin/valkey-benchmark
	dosym valkey-server /usr/sbin/valkey-sentinel

	if use prefix; then
		diropts -m0750
	else
		diropts -m0750 -o valkey -g valkey
	fi
	keepdir /var/{log,lib}/valkey
}

pkg_postinst() {
	tmpfiles_process valkey.conf
}
