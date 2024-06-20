# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# N.B.: It is no clue in porting to Lua eclasses, as upstream have deviated
# too far from vanilla Lua, adding their own APIs like lua_enablereadonlytable

inherit autotools edo multiprocessing systemd tmpfiles toolchain-funcs

DESCRIPTION="A persistent caching system, key-value, and data structures database"
HOMEPAGE="
	https://redis.io
	https://github.com/redis/redis
"
SRC_URI="https://download.redis.io/releases/${P}.tar.gz"

LICENSE="BSD Boost-1.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="+jemalloc selinux ssl systemd tcmalloc test"
RESTRICT="!test? ( test )"

DEPEND="
	jemalloc? ( >=dev-libs/jemalloc-5.1:= )
	ssl? ( dev-libs/openssl:0= )
	systemd? ( sys-apps/systemd:= )
	tcmalloc? ( dev-util/google-perftools )
"

RDEPEND="
	${DEPEND}
	acct-group/redis
	acct-user/redis
	selinux? ( sec-policy/selinux-redis )
"

BDEPEND="
	acct-group/redis
	acct-user/redis
	virtual/pkgconfig
	test? (
		dev-lang/tcl:0=
		ssl? ( dev-tcltk/tls )
	)
"

REQUIRED_USE="?? ( jemalloc tcmalloc )"

PATCHES=(
	"${FILESDIR}"/${PN}-6.2.1-config.patch
	"${FILESDIR}"/${PN}-7.2.0-system-jemalloc.patch
	"${FILESDIR}"/${PN}-6.2.3-ppc-atomic.patch
	"${FILESDIR}"/${PN}-sentinel-7.2.0-config.patch
	"${FILESDIR}"/${PN}-7.0.4-no-which.patch
)

src_prepare() {
	default

	# Respect user CFLAGS in bundled lua
	sed -i '/LUA_CFLAGS/s: -O2::g' deps/Makefile || die

	# now we will rewrite present Makefiles
	local makefiles="" MKF
	local mysedconf=(
		-e 's:$(CC):@CC@:g'
		-e 's:$(CFLAGS):@AM_CFLAGS@:g'
		-e 's: $(DEBUG)::g'

		-e 's:-Werror ::g'
		-e 's:-Werror=deprecated-declarations ::g'
	)
	for MKF in $(find -name 'Makefile' | cut -b 3-); do
		mv "${MKF}" "${MKF}.in"
		sed -i "${mysedconf[@]}" "${MKF}.in" || die "Sed failed for ${MKF}"
		makefiles+=" ${MKF}"
	done
	# autodetection of compiler and settings; generates the modified Makefiles
	cp "${FILESDIR}"/configure.ac-7.0 configure.ac || die

	sed -i \
		-e "/^AC_INIT/s|, __PV__, |, $PV, |" \
		-e "s:AC_CONFIG_FILES(\[Makefile\]):AC_CONFIG_FILES([${makefiles}]):g" \
		configure.ac || die "Sed failed for configure.ac"
	eautoreconf
}

src_configure() {
	econf

	# Linenoise can't be built with -std=c99, see https://bugs.gentoo.org/451164
	# also, don't define ANSI/c99 for lua twice
	sed -i -e "s:-std=c99::g" deps/linenoise/Makefile deps/Makefile || die
}

src_compile() {
	tc-export AR CC RANLIB

	local myconf=(
		AR="${AR}"
		CC="${CC}"
		RANLIB="${RANLIB}"

		V=1 # verbose

		# OPTIMIZATION defaults to -O3. Let's respect user CFLAGS by setting it
		# to empty value.
		OPTIMIZATION=''
		# Disable debug flags in bundled hiredis
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
		--clients "$(makeopts_jobs)" # see bug #649868

		--skiptest "Active defrag eval scripts" # see bug #851654
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
	insinto /etc/redis
	doins redis.conf sentinel.conf
	use prefix || fowners -R redis:redis /etc/redis /etc/redis/{redis,sentinel}.conf
	fperms 0750 /etc/redis
	fperms 0644 /etc/redis/{redis,sentinel}.conf

	newconfd "${FILESDIR}/redis.confd-r2" redis
	newinitd "${FILESDIR}/redis.initd-6" redis

	systemd_newunit "${FILESDIR}/redis.service-4" redis.service
	newtmpfiles "${FILESDIR}/redis.tmpfiles-2" redis.conf

	newconfd "${FILESDIR}/redis-sentinel.confd-r1" redis-sentinel
	newinitd "${FILESDIR}/redis-sentinel.initd-r1" redis-sentinel

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	dodoc 00-RELEASENOTES BUGS CONTRIBUTING.md MANIFESTO README.md

	dobin src/redis-cli
	dosbin src/redis-benchmark src/redis-server src/redis-check-aof src/redis-check-rdb
	fperms 0750 /usr/sbin/redis-benchmark
	dosym redis-server /usr/sbin/redis-sentinel

	if use prefix; then
		diropts -m0750
	else
		diropts -m0750 -o redis -g redis
	fi
	keepdir /var/{log,lib}/redis
}

pkg_postinst() {
	tmpfiles_process redis.conf

	ewarn "The default redis configuration file location changed to:"
	ewarn "  /etc/redis/{redis,sentinel}.conf"
	ewarn "Please apply your changes to the new configuration files."
}
