# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/redis/redis-2.8.19-r1.ebuild,v 1.2 2015/03/25 08:04:11 jlec Exp $

EAPI=5

inherit autotools eutils flag-o-matic systemd toolchain-funcs user

DESCRIPTION="A persistent caching system, key-value and data structures database"
HOMEPAGE="http://redis.io/"
SRC_URI="http://download.redis.io/releases/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~amd64-linux ~hppa ~x86 ~x86-linux ~x86-macos ~x86-solaris"
IUSE="+jemalloc tcmalloc test"
SLOT="0"

RDEPEND=">=dev-lang/lua-5.1:*
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
	epatch "${FILESDIR}"/${PN}-2.8.3-shared.patch
	epatch "${FILESDIR}"/${PN}-2.8.17-config.patch
	epatch "${FILESDIR}"/${P}-sharedlua.patch

	# Copy lua modules into build dir
	cp "${S}"/deps/lua/src/{fpconv,lua_bit,lua_cjson,lua_cmsgpack,lua_struct,strbuf}.c "${S}"/src || die
	cp "${S}"/deps/lua/src/{fpconv,strbuf}.h "${S}"/src || die
	# Append cflag for lua_cjson
	# https://github.com/antirez/redis/commit/4fdcd213#diff-3ba529ae517f6b57803af0502f52a40bL61
	append-cflags "-DENABLE_CJSON_GLOBAL"

	# Avoid glibc noise
	# https://github.com/antirez/redis/pull/2189
	[[ ${CHOST} == *linux* ]] && append-cflags "-D_DEFAULT_SOURCE"

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
	cp "${FILESDIR}"/configure.ac-2.2 configure.ac
	sed -i	-e "s:AC_CONFIG_FILES(\[Makefile\]):AC_CONFIG_FILES([${makefiles}]):g" \
		configure.ac || die "Sed failed for configure.ac"
	eautoconf
}

src_configure() {
	econf

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

	newconfd "${FILESDIR}/redis.confd" redis
	newinitd "${FILESDIR}/redis.initd-4" redis

	systemd_dounit "${FILESDIR}/redis.service"
	systemd_newtmpfilesd "${FILESDIR}/redis.tmpfiles" redis.conf

	nonfatal dodoc 00-RELEASENOTES BUGS CONTRIBUTING MANIFESTO README

	dobin src/redis-cli
	dosbin src/redis-benchmark src/redis-server src/redis-check-aof src/redis-check-dump
	fperms 0750 /usr/sbin/redis-benchmark
	dosym /usr/sbin/redis-server /usr/sbin/redis-sentinel

	if use prefix; then
		diropts -m0750
	else
		diropts -m0750 -o redis -g redis
	fi
	keepdir /var/{log,lib}/redis
}
