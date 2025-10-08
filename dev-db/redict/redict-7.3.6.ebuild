# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# N.B.: It is no clue in porting to Lua eclasses, as upstream have deviated
# too far from vanilla Lua, adding their own APIs like lua_enablereadonlytable

inherit edo multiprocessing systemd tmpfiles toolchain-funcs

DESCRIPTION="A persistent caching system, key-value, and data structures database"
HOMEPAGE="https://redict.io"

SRC_URI="https://codeberg.org/redict/redict/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"

S=${WORKDIR}/${PN}

LICENSE="BSD Boost-1.0 LGPL-3"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="+jemalloc ssl systemd tcmalloc test"
RESTRICT="!test? ( test )"

REQUIRED_USE="?? ( jemalloc tcmalloc )"

RDEPEND="
	acct-group/redict
	acct-user/redict
	dev-libs/hiredict:0=[ssl?]
	jemalloc? ( >=dev-libs/jemalloc-5.1:=[stats] )
	ssl? ( dev-libs/openssl:0= )
	systemd? ( sys-apps/systemd:= )
	tcmalloc? ( dev-util/google-perftools )
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	test? (
		dev-lang/tcl:0=
		ssl? ( dev-tcltk/tls )
	)
"

PATCHES=(
	"${FILESDIR}"/redict-7.3.0-config.patch
	"${FILESDIR}"/redict-sentinel-7.3.0-config.patch
	"${FILESDIR}"/redict-7.3.0-system-jemalloc.patch
	"${FILESDIR}"/redict-7.3.0-system-hiredict.patch
)

src_prepare() {
	default

	# Respect user CFLAGS in bundled lua
	sed -i '/LUA_CFLAGS/s: -O2::g' deps/Makefile || die
}

_build() {
	tc-export AR CC RANLIB
	local myconf=(
		AR="${AR}"
		CC="${CC}"
		RANLIB="${RANLIB}"
		CFLAGS="${CFLAGS}"
		LDFLAGS="${LDFLAGS}"
		V=1 # verbose
		OPTIMIZATION=
		DEBUG=
		DEBUG_FLAGS=
		BUILD_TLS=$(usex ssl)
		USE_SYSTEMD=$(usex systemd)
		USE_SYSTEM_HIREDICT=yes
	)

	if use jemalloc; then
		myconf+=(
			MALLOC=jemalloc
			USE_SYSTEM_JEMALLOC=yes
		)
	elif use tcmalloc; then
		myconf+=( MALLOC=tcmalloc )
	else
		myconf+=( MALLOC=libc )
	fi

	emake -C src "${myconf[@]}" "$@"
}

src_compile() {
	_build
}

src_test() {
	local runtestargs=(
		--clients "$(makeopts_jobs)" # see bug #649868

		--skiptest "Active defrag eval scripts" # see bug #851654
		--skiptest "FUNCTION - redict version api" # test fails due to release mishap on 7.3.1, remove on bump
	)

	if has usersandbox ${FEATURES} || ! has userpriv ${FEATURES}; then
		ewarn "oom-score-adj related tests will be skipped." \
			"They are known to fail with FEATURES usersandbox or -userpriv. See bug #756382."

		runtestargs+=(
			# unit/oom-score-adj was introduced in version 6.2.0
			--skipunit unit/oom-score-adj # see bug #756382

			# Following test was added in version 7.0.0 to unit/introspection.
			# It also tries to adjust OOM score.
			--skiptest "CONFIG SET rollback on apply error"
		)
	fi

	if use ssl; then
		edo ./utils/gen-test-certs.sh
		runtestargs+=( --tls )
	fi

	edo ./runtest "${runtestargs[@]}"
}

src_install() {
	insinto /etc/redict
	doins redict.conf sentinel.conf
	use prefix || fowners -R redict:redict /etc/redict /etc/redict/{redict,sentinel}.conf

	newconfd "${FILESDIR}/redict.confd" redict
	newinitd "${FILESDIR}/redict.initd" redict

	systemd_newunit "${FILESDIR}/redict.service" redict.service
	newtmpfiles "${FILESDIR}/redict.tmpfiles" redict.conf

	newconfd "${FILESDIR}/redict-sentinel.confd" redict-sentinel
	newinitd "${FILESDIR}/redict-sentinel.initd" redict-sentinel

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/redict.logrotate" "${PN}"

	_build DESTDIR="${ED}" PREFIX="/usr" install

	if use prefix; then
		diropts -m0750
	else
		diropts -m0750 -o redict -g redict
	fi
	keepdir /var/{log,lib}/redict
}

pkg_postinst() {
	tmpfiles_process redict.conf

	if has_version dev-db/redis && [[ -z "${REPLACING_VERSIONS}" ]]; then
		ewarn "Redict uses different configuration files than redis:"
		ewarn "/etc/redict/{redict,sentinel}.conf"
		ewarn "Please apply your changes to the new configuration files."
	fi
}
