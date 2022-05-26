# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic systemd toolchain-funcs tmpfiles

DESCRIPTION="A persistent caching system, key-value and data structures database"
HOMEPAGE="https://redis.io"
SRC_URI="http://download.redis.io/releases/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="+jemalloc tcmalloc luajit selinux test"
RESTRICT="!test? ( test )"

# Redis does NOT build with Lua 5.2 or newer at this time.
COMMON_DEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( dev-lang/lua:5.1 )
	tcmalloc? ( dev-util/google-perftools )
	jemalloc? ( >=dev-libs/jemalloc-5.1:= )"

RDEPEND="
	${COMMON_DEPEND}
	acct-group/redis
	acct-user/redis
	selinux? ( sec-policy/selinux-redis )"

BDEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig"

# Tcl is only needed in the CHOST test env
DEPEND="
	${COMMON_DEPEND}
	test? ( dev-lang/tcl:0= )"

REQUIRED_USE="?? ( tcmalloc jemalloc )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.3-config.patch
	"${FILESDIR}"/${PN}-5.0-shared.patch
	"${FILESDIR}"/${PN}-5.0-sharedlua.patch
	"${FILESDIR}"/${PN}-5.0.8-ppc-atomic.patch
	"${FILESDIR}"/${PN}-sentinel-5.0-config.patch
)

src_prepare() {
	default

	# don't call ar directly
	sed -e '/^STLIB_MAKE_CMD/s/ar/$(AR)/g' \
		-i deps/hiredis/Makefile || die

	# Copy lua modules into build dir
	cp deps/lua/src/{fpconv,lua_bit,lua_cjson,lua_cmsgpack,lua_struct,strbuf}.c src/ || die
	cp deps/lua/src/{fpconv,strbuf}.h src/ || die
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
	cp "${FILESDIR}"/configure.ac-3.2 configure.ac || die

	# Use the correct pkgconfig name for Lua
	if false && has_version 'dev-lang/lua:5.3'; then
		# Lua5.3 gives:
		#lua_bit.c:83:2: error: #error "Unknown number type, check LUA_NUMBER_* in luaconf.h"
		LUAPKGCONFIG=lua5.3
	elif false && has_version 'dev-lang/lua:5.2'; then
		# Lua5.2 fails with:
		# scripting.c:(.text+0x1f9b): undefined reference to `lua_open'
		# Because lua_open because lua_newstate in 5.2
		LUAPKGCONFIG=lua5.2
	elif has_version 'dev-lang/lua:5.1'; then
		LUAPKGCONFIG=lua5.1
	else
		LUAPKGCONFIG=lua
	fi
	# The upstream configure script handles luajit specially, and is not
	# effected by these changes.
	einfo "Selected LUAPKGCONFIG=${LUAPKGCONFIG}"
	sed -i	\
		-e "/^AC_INIT/s|, [0-9].+, |, $PV, |" \
		-e "s:AC_CONFIG_FILES(\[Makefile\]):AC_CONFIG_FILES([${makefiles}]):g" \
		-e "/PKG_CHECK_MODULES.*\<LUA\>/s,lua5.1,${LUAPKGCONFIG},g" \
		configure.ac || die "Sed failed for configure.ac"
	eautoreconf
}

src_configure() {
	econf $(use_with luajit)

	# Linenoise can't be built with -std=c99, see https://bugs.gentoo.org/451164
	# also, don't define ANSI/c99 for lua twice
	sed -i -e "s:-std=c99::g" deps/linenoise/Makefile deps/Makefile || die
}

src_compile() {
	local myconf=""

	if use tcmalloc; then
		myconf="${myconf} USE_TCMALLOC=yes"
	elif use jemalloc; then
		myconf="${myconf} JEMALLOC_SHARED=yes"
	else
		myconf="${myconf} MALLOC=yes"
	fi

	tc-export AR CC RANLIB
	emake V=1 ${myconf} AR="${AR}" CC="${CC}" RANLIB="${RANLIB}"
}

src_install() {
	insinto /etc/
	doins redis.conf sentinel.conf
	use prefix || fowners redis:redis /etc/{redis,sentinel}.conf
	fperms 0644 /etc/{redis,sentinel}.conf

	newconfd "${FILESDIR}/redis.confd-r1" redis
	newinitd "${FILESDIR}/redis.initd-5" redis

	systemd_newunit "${FILESDIR}/redis.service-3" redis.service
	newtmpfiles "${FILESDIR}/redis.tmpfiles-2" redis.conf

	newconfd "${FILESDIR}/redis-sentinel.confd" redis-sentinel
	newinitd "${FILESDIR}/redis-sentinel.initd" redis-sentinel

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
}
