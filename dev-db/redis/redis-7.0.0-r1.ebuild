# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# N.B.: It is no clue in porting to Lua eclasses, as upstream have deviated
# too far from vanilla Lua, adding their own APIs like lua_enablereadonlytable

inherit autotools edo flag-o-matic multiprocessing systemd tmpfiles toolchain-funcs

DESCRIPTION="A persistent caching system, key-value, and data structures database"
HOMEPAGE="https://redis.io"
SRC_URI="https://download.redis.io/releases/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="+jemalloc ssl systemd tcmalloc test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	jemalloc? ( >=dev-libs/jemalloc-5.1:= )
	ssl? ( dev-libs/openssl:0= )
	systemd? ( sys-apps/systemd:= )
	tcmalloc? ( dev-util/google-perftools )
"

RDEPEND="
	${COMMON_DEPEND}
	acct-group/redis
	acct-user/redis
"

BDEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
"

# Tcl is only needed in the CHOST test env
DEPEND="
	test? (
		dev-lang/tcl:0=
		ssl? ( dev-tcltk/tls )
	)"

REQUIRED_USE="?? ( jemalloc tcmalloc )"

PATCHES=(
	"${FILESDIR}"/${PN}-6.2.1-config.patch
	"${FILESDIR}"/${PN}-5.0-shared.patch
	"${FILESDIR}"/${PN}-6.2.3-ppc-atomic.patch
	"${FILESDIR}"/${PN}-sentinel-5.0-config.patch
)

src_prepare() {
	default

	# Append cflag for lua_cjson
	# https://github.com/antirez/redis/commit/4fdcd213#diff-3ba529ae517f6b57803af0502f52a40bL61
	append-cflags "-DENABLE_CJSON_GLOBAL"

	# now we will rewrite present Makefiles
	local makefiles="" MKF
	for MKF in $(find -name 'Makefile' | cut -b 3-); do
		mv "${MKF}" "${MKF}.in"
		sed -i	-e 's:$(CC):@CC@:g' \
			-e 's:$(CFLAGS):@AM_CFLAGS@:g' \
			-e 's: $(DEBUG)::g' \
			-e 's:$(OBJARCH)::g' \
			-e 's:ARCH:TARCH:g' \
			-e '/^CCOPT=/s:$: $(LDFLAGS):g' \
			"${MKF}.in" \
		|| die "Sed failed for ${MKF}"
		makefiles+=" ${MKF}"
	done
	# autodetection of compiler and settings; generates the modified Makefiles
	cp "${FILESDIR}"/configure.ac-7.0 configure.ac || die

	sed -i	\
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
	local myconf=""

	if use jemalloc; then
		myconf+="MALLOC=jemalloc"
	elif use tcmalloc; then
		myconf+="MALLOC=tcmalloc"
	else
		myconf+="MALLOC=libc"
	fi

	if use ssl; then
		myconf+=" BUILD_TLS=yes"
	fi

	export USE_SYSTEMD=$(usex systemd)

	tc-export AR CC RANLIB
	emake V=1 ${myconf} AR="${AR}" CC="${CC}" RANLIB="${RANLIB}"
}

src_test() {
	local runtestargs=(
		--clients "$(makeopts_jobs)" # see bug #649868
	)

	# Known to fail with FEATURES=usersandbox
	if has usersandbox ${FEATURES}; then
		ewarn "You are emerging ${P} with 'usersandbox' enabled." \
			"Expect some test failures or emerge with 'FEATURES=-usersandbox'!"
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

	dodoc 00-RELEASENOTES BUGS CONTRIBUTING MANIFESTO README.md

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
