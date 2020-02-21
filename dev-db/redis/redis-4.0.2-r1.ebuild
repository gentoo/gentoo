# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic systemd toolchain-funcs user

DESCRIPTION="A persistent caching system, key-value and data structures database"
HOMEPAGE="http://redis.io/"
SRC_URI="http://download.redis.io/releases/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 arm arm64 hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE="+jemalloc tcmalloc luajit test"
RESTRICT="!test? ( test )"
SLOT="0"

# Redis does NOT build with Lua 5.2 or newer at this time.
# This should link correctly with both unslotted & slotted Lua, without
# changes.
RDEPEND="luajit? ( dev-lang/luajit:2 )
	!luajit? ( || ( dev-lang/lua:5.1 =dev-lang/lua-5.1*:0 ) )
	tcmalloc? ( dev-util/google-perftools )
	jemalloc? ( >=dev-libs/jemalloc-3.2 )"
DEPEND="virtual/pkgconfig
	>=sys-devel/autoconf-2.63
	test? ( dev-lang/tcl:0= )
	${RDEPEND}"
REQUIRED_USE="?? ( tcmalloc jemalloc )"

S="${WORKDIR}/${PN}-${PV/_/-}"

pkg_setup() {
	enewgroup redis 75
	enewuser redis 75 -1 /var/lib/redis redis
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-4.0.1-shared.patch \
		"${FILESDIR}"/${PN}-3.2.3-config.patch \
		"${FILESDIR}"/${PN}-4.0.1-sharedlua.patch
	eapply_user

	# Copy lua modules into build dir
	cp "${S}"/deps/lua/src/{fpconv,lua_bit,lua_cjson,lua_cmsgpack,lua_struct,strbuf}.c "${S}"/src || die
	cp "${S}"/deps/lua/src/{fpconv,strbuf}.h "${S}"/src || die
	# Append cflag for lua_cjson
	# https://github.com/antirez/redis/commit/4fdcd213#diff-3ba529ae517f6b57803af0502f52a40bL61
	append-cflags "-DENABLE_CJSON_GLOBAL"

	# now we will rewrite present Makefiles
	local makefiles=""
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
	cp "${FILESDIR}"/configure.ac-3.2 configure.ac

	# Use the correct pkgconfig name for Lua
	has_version 'dev-lang/lua:5.1' \
		&& LUAPKGCONFIG=lua5.1 \
		|| LUAPKGCONFIG=lua
	sed -i	\
		-e "/^AC_INIT/s|, [0-9].+, |, $PV, |" \
		-e "s:AC_CONFIG_FILES(\[Makefile\]):AC_CONFIG_FILES([${makefiles}]):g" \
		-e "/PKG_CHECK_MODULES.*\<LUA\>/s,lua5.1,${LUAPKGCONFIG},g" \
		configure.ac || die "Sed failed for configure.ac"
	eautoreconf
}

src_configure() {
	econf \
		$(use_with luajit)

	# Linenoise can't be built with -std=c99, see https://bugs.gentoo.org/451164
	# also, don't define ANSI/c99 for lua twice
	sed -i -e "s:-std=c99::g" deps/linenoise/Makefile deps/Makefile || die
}

src_compile() {
	tc-export CC AR RANLIB

	local myconf=""

	if use tcmalloc ; then
		myconf="${myconf} USE_TCMALLOC=yes"
	elif use jemalloc ; then
		myconf="${myconf} JEMALLOC_SHARED=yes"
	else
		myconf="${myconf} MALLOC=yes"
	fi

	emake ${myconf} V=1 CC="${CC}" AR="${AR} rcu" RANLIB="${RANLIB}"
}

src_install() {
	insinto /etc/
	doins redis.conf sentinel.conf
	use prefix || fowners redis:redis /etc/{redis,sentinel}.conf
	fperms 0644 /etc/{redis,sentinel}.conf

	newconfd "${FILESDIR}/redis.confd-r1" redis
	newinitd "${FILESDIR}/redis.initd-5" redis

	systemd_newunit "${FILESDIR}/redis.service-2" redis.service
	systemd_newtmpfilesd "${FILESDIR}/redis.tmpfiles" redis.conf

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
