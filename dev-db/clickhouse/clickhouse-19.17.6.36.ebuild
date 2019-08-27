# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic llvm systemd toolchain-funcs

DESCRIPTION="An OSS column-oriented database management system for real-time data analysis"
HOMEPAGE="https://clickhouse.yandex"
LICENSE="Apache-2.0"

MY_PN="ClickHouse"
IUSE="
	cpu_flags_x86_sse2
	cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2 cpu_flags_x86_ssse3 cpu_flags_x86_pclmul
	cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_fma3
	+base64 brotli capnp +client debug doc +fastops hdfs3 hyperscan icu +jemalloc +json
	kafka libcxx libedit llvm libressl +libunwind mongodb mysql odbc orc parquet
	protobuf readline +server split-binary ssl +static +static-libs tcmalloc test tools
"

REQUIRED_USE="
	split-binary? ( !static-libs )
	server? ( cpu_flags_x86_sse2 cpu_flags_x86_sse4_2 )
	fastops? (
		|| ( cpu_flags_x86_avx cpu_flags_x86_avx2 )
	)
	fastops? ( cpu_flags_x86_avx2? ( cpu_flags_x86_fma3 ) )
	json? ( cpu_flags_x86_avx2? ( cpu_flags_x86_pclmul ) )
	hdfs3? ( protobuf )
	static? ( client server tools )
	libressl? ( ssl )
	parquet? ( protobuf )
	orc? ( parquet )
	readline? ( client !libedit )
	libedit? ( client !readline )
	kafka? ( ssl )
	?? ( tcmalloc jemalloc )
"
RESTRICT="!test? ( test )"

if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/${MY_PN}/${MY_PN}.git"
	EGIT_SUBMODULES=( '*'
		-contrib/boost			-contrib/brotli		-contrib/capnproto
		-contrib/double-conversion	-contrib/googletest	-contrib/hyperscan
		-contrib/jemalloc		-contrib/libcxx		-contrib/libcxxabi
		-contrib/librdkafka		-contrib/libxml2	-contrib/llvm
		-contrib/lz4			-contrib/mariadb-connector-c
		-contrib/protobuf		-contrib/ssl		-contrib/unixodbc
		-contrib/zstd			'-contrib/*/*'
	)
	TYPE="unstable"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	TYPE="stable"

	KEYWORDS="~amd64"  # Worth trying with: ~arm ~arm64 ~amd64-fbsd ~amd64-linux ~x64-macos"

	# To bump new version:
	# 1. Update commits bellow to match submodules in contrib/, match commits with package versions
	# 2. Add new dependencies: packages or SRC_URIs, check if some deps were dropped
	# 3. Check if existing vendored libs can be replaced with system ones, update CLICKHOUSE_DEPS
	# 4. Check if some libs there were patched so we need to vendor them, add blocks *DEPEPND_BASE

	ARROW_COMMIT="87ac6fdd"   # not yet in portage
	BASE64_COMMIT="a27c565"  # not yet in portage
	BOOST_COMMOT="830e51e"  # stripped down version 1.70
	BROTLI_COMMIT="5805f99"  # unstable version, not in portage, but stable should work
	CAPNPROTO_COMMIT="a00ccd9"  # unstable version, not in portage, but stable should work
	CCTZ_COMMIT="4f9776a"  # not yet in portage, version pre-2.2
	CPPKAFKA_COMMIT="9b184d8"  # not yet in portage, using external library is not supported by upstream yet
	DOUBLE_CONVERSION_COMMIT="cf2f0f3"  # untagged version a few commits after v3.0.0, newer portage version should work
	FASTOPS_COMMIT="88752a5"  # new experimental library
	GOOGLE_TEST_COMMIT="d175c8b"  # in-between 1.8.0 and 1.8.1
	H3_COMMIT="6cfd649"  # not yet in portage
	HYPERSCAN_COMMIT="3058c9c"  # slightly patched version 5.1.1
	JEMALLOC_COMMIT="cd2931a"  # somewhere in-between 5.1.0 and 5.2.0
	LIBCXX_COMMIT="9807685"  # git-svm mirror pointing to something like 9.0.0svn
	LIBCXXABI_COMMIT="d56efcc"  # same as libcxx
	LIBGSASL_COMMIT="3b8948a"  # commit from ClickHouse-Extras, exact version or diffs are unknown :(
	LIBHDFS3_COMMIT="e2131aa"  # optional part of ClickHouse, not an external library
	LIBRDKAFKA_COMMIT="6160ec2"  # 1.1.0
	LIBUNWIND_COMMIT="68cffcb"  # patched
	LIBXML_COMMIT="18890f4"  # 2.9.8
	LLVM_COMMIT="163def2"  # stripped down LLVM5
	LZ4_COMMIT="7a4e3b1"  # almost 1.9.1
	MARIADB_CONNECTOR_C_COMMIT="1801630"  # patched pre-3.1.0
	ORC_COMMIT="5981208"  # somewhat before 1.5.1
	POCO_COMMIT="d478f62"  # highly patched
	PROTOBUF_COMMIT="0795fa6"  # stripped protobuf-cpp@3.6.1
	RAPIDJSON_COMMIT="01950eb"  # after 1.1.0, untagged, not yet in portage
	RE2_COMMIT="7cf8b88"  # alomost 2018.01.01, static version is not supported in portage
	SIMDJSON_COMMIT="6091631"  # unstable, newer than v0.2.1
	SNAPPY_COMMIT="3f194ac"  # unstable, 33 commits after 1.1.7
	SPARSEHASH_C11_COMMIT="cf0bffa"  # unstable, experimental
	SSL_COMMIT="ba8de79"  # some fork of libressl-portable, only static builds are supported
	THRIFT_COMMIT="010ccf0"  # unstable, targeting 1.0.0
	UNIXODBC_COMMIT="b0ad30f"  # single-commit "fork" with unknown changes or diff :(
	ZLIB_NG_COMMIT="cff0f50"  # patched zlib-ng which is a replacement for zlib, not yet in portage
	ZSTD_COMMIT="2555975"  # about 1.3.4

	SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${PV}-${TYPE}.tar.gz -> ${P}.tar.gz
		https://github.com/aklomp/base64/archive/${BASE64_COMMIT}.tar.gz -> base64-${BASE64_COMMIT}.tar.gz
		https://github.com/google/cctz/archive/${CCTZ_COMMIT}.tar.gz -> cctz-${CCTZ_COMMIT}.tar.gz
		fastops? ( https://github.com/ClickHouse-Extras/fastops/archive/${FASTOPS_COMMIT}.tar.gz -> fastops-${FASTOPS_COMMIT}.tar.gz )
		https://github.com/uber/h3/archive/${H3_COMMIT}.tar.gz -> h3-${H3_COMMIT}.tar.gz
		hdfs3? ( https://github.com/ClickHouse-Extras/libhdfs3/archive/${LIBHDFS3_COMMIT}.tar.gz -> libhdfs3-${LIBHDFS3_COMMIT}.tar.gz )
		json? (
			https://github.com/Tencent/rapidjson/archive/${RAPIDJSON_COMMIT}.tar.gz -> rapidjson-${RAPIDJSON_COMMIT}.tar.gz
			https://github.com/lemire/simdjson/archive/${SIMDJSON_COMMIT}.tar.gz -> simdjson-${SIMDJSON_COMMIT}.tar.gz
		)
		kafka? ( https://github.com/ClickHouse-Extras/cppkafka/archive/${CPPKAFKA_COMMIT}.tar.gz -> cppkafka-${CPPKAFKA_COMMIT}.tar.gz )
		libunwind? ( https://github.com/ClickHouse-Extras/libunwind/archive/${LIBUNWIND_COMMIT}.tar.gz -> libunwind-${LIBUNWIND_COMMIT}.tar.gz )
		https://github.com/ClickHouse-Extras/poco/archive/${POCO_COMMIT}.tar.gz -> poco-${POCO_COMMIT}.tar.gz
		static? (
			https://github.com/ClickHouse-Extras/libgsasl/archive/${LIBGSASL_COMMIT}.tar.gz -> libgsasl-clickhouse-${LIBGSASL_COMMIT}.tar.gz
			https://github.com/google/re2/archive/${RE2_COMMIT}.tar.gz -> re2-${RE2_COMMIT}.tar.gz
		)
		orc? (
			https://github.com/apache/orc/archive/${ORC_COMMIT}.tar.gz -> apache-orc-${ORC_COMMIT}.tar.gz
		)
		parquet? (
			https://github.com/apache/arrow/archive/${ARROW_COMMIT}.tar.gz -> arrow-${ARROW_COMMIT}.tar.gz
			https://github.com/google/snappy/archive/${SNAPPY_COMMIT}.tar.gz -> snappy-${SNAPPY_COMMIT}.tar.gz
			https://github.com/apache/thrift/archive/${THRIFT_COMMIT}.tar.gz -> thrift-${THRIFT_COMMIT}.tar.gz
		)
		https://github.com/sparsehash/sparsehash-c11/archive/${SPARSEHASH_C11_COMMIT}.tar.gz -> sparsehash-c11-${SPARSEHASH_C11_COMMIT}.tar.gz
		https://github.com/ClickHouse-Extras/zlib-ng/archive/${ZLIB_NG_COMMIT}.tar.gz -> zlib-ng-${ZLIB_NG_COMMIT}.tar.gz
	"
	S="${WORKDIR}/${MY_PN}-${PV}-${TYPE}"
fi

PATCHES="
	${FILESDIR}/unbundle-r1.patch
	${FILESDIR}/zlib-ng-change-name.patch
"

RDEPEND_BASE="
	acct-user/clickhouse
	acct-group/clickhouse
	!static? (
		libunwind? ( !sys-libs/libunwind )
		!dev-libs/poco
		parquet? ( !app-arch/snappy )
		libcxx? (
			libunwind? ( sys-libs/libcxx[-libunwind] )
		)
		llvm? (
			<sys-devel/llvm-7.2.0:=
			sys-devel/clang:=[static-analyzer]
			readline? ( >=sys-devel/llvm-5.0.0:=[ncurses] )
		)
		mysql? (
			|| (
				mysql? (
					>=dev-db/mariadb-connector-c-3.1.0
					!dev-db/mysql-connector-c
				)
				mysql? (
					!dev-db/mariadb-connector-c
					dev-db/mysql-connector-c
				)
			)
		)
		>=dev-libs/re2-0.2018.01.01:0=
		|| ( net-libs/libgsasl net-misc/gsasl )
		ssl? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
		libedit? ( sys-libs/ncurses:0=[tinfo] )
		readline? ( sys-libs/ncurses:0=[tinfo] )
		parquet? ( dev-libs/cyrus-sasl )
	)
	elibc_FreeBSD? ( dev-libs/libexecinfo )
"

DEPEND_BASE="${RDEPEND_BASE}
	static? (
		!static-libs? (
			libunwind? ( !sys-libs/libunwind )
			!dev-libs/poco
			parquet? ( !app-arch/snappy )
		)
		libcxx? (
			libunwind? ( sys-libs/libcxx[-libunwind] )
		)
		llvm? (
			<sys-devel/llvm-7.2.0:=
			sys-devel/clang:=[static-analyzer]
			readline? ( >=sys-devel/llvm-5.0.0:=[ncurses] )
		)
		mysql? (
			|| (
				mysql? (
					>=dev-db/mariadb-connector-c-3.1.0[static-libs]
					!dev-db/mysql-connector-c
				)
				mysql? (
					!dev-db/mariadb-connector-c
					dev-db/mysql-connector-c[static-libs]
				)
			)
		)
		ssl? (
			!libressl? ( dev-libs/openssl:0=[static-libs] )
			libressl? ( dev-libs/libressl:0=[static-libs] )
		)
		libedit? ( sys-libs/ncurses:0=[static-libs,tinfo] )
		readline? ( sys-libs/ncurses:0=[static-libs,tinfo] )
		parquet? ( dev-libs/cyrus-sasl[static-libs] )
	)
"

BDEPEND="
	doc? (
		dev-python/jsmin
		dev-python/cssmin
		app-text/htmlmin
		dev-python/python-slugify
		>=dev-python/beautifulsoup-4.6.3
		>=dev-python/mkdocs-1.0.1
		>=www-servers/tornado-5.0
		<=dev-python/markdown-2.7
	)
	protobuf? ( >=dev-libs/protobuf-3.6.1:= )
	|| (
		>=sys-devel/gcc-8.0.0
		>=sys-devel/clang-7.0
	)
"

SLOT="0/${TYPE}"

CLICKHOUSE_DEPS=(
	#component/contrib_dir	use_flag	source archive or DEPEND
	#	disable_internal			check_cmake_variable	set_cmake_arg (if optional)
	"arrow			parquet		arrow-${ARROW_COMMIT}.tar.gz \
		USE_INTERNAL_PARQUET_LIBRARY=yes	USE_PARQUET		ENABLE_PARQUET"
	"base64			base64		base64-${BASE64_COMMIT}.tar.gz \
		USE_INTERNAL_BASE64_LIBRARY=yes		USE_BASE64		ENABLE_BASE64"
	#			empty use_flag=always
	"boost			-		>=dev-libs/boost-1.70.0:=[icu?,static-libs] \
		USE_INTERNAL_BOOST_LIBRARY=no		Boost_FOUND"
	"brotli			brotli		>=app-arch/brotli-1.0.7:=[static-libs(+)] \
		USE_INTERNAL_BROTLI_LIBRARY=no		USE_BROTLI		ENABLE_BROTLI"
	"capnproto		capnp		>=dev-libs/capnproto-0.7.0[static-libs] \
		USE_INTERNAL_CAPNP_LIBRARY=no		USE_CAPNP		ENABLE_CAPNP"
	"cctz			-		cctz-${CCTZ_COMMIT}.tar.gz \
		USE_INTERNAL_CCTZ_LIBRARY=yes		USE_INTERNAL_CCTZ_LIBRARY"
	#					empty source=added manually to DEPEND or vendored directly
	"citihash		-		-	\
		USE_INTERNAL_CITYHASH_LIBRARY=yes	USE_INTERNAL_CITYHASH_LIBRARY"
	"consistent_hashing	-		- \
		USE_INTERNAL_CONSISTENT_HASHING_LIBRARY=yes	USE_INTERNAL_CONSISTENT_HASHING_LIBRARY"
	"cppkafka		kafka		cppkafka-${CPPKAFKA_COMMIT}.tar.gz \
		USE_INTERNAL_CPPKAFKA_LIBRARY=yes	USE_INTERNAL_CPPKAFKA_LIBRARY"
	"double-conversion	-		dev-libs/double-conversion[static-libs] \
		USE_INTERNAL_DOUBLE_CONVERSION_LIBRARY=no	DOUBLE_CONVERSION_INCLUDE_DIR"
	"h3			-		h3-${H3_COMMIT}.tar.gz \
		USE_INTERNAL_H3_LIBRARY=yes		USE_H3"
	"hyperscan		hyperscan	>=dev-libs/hyperscan-5.1.1[static-libs] \
		USE_INTERNAL_HYPERSCAN_LIBRARY=no	USE_HYPERSCAN		ENABLE_HYPERSCAN"
	"icu			icu		dev-libs/icu[static-libs] \
		USE_INTERNAL_ICU_LIBRARY=no		USE_ICU			ENABLE_ICU"
	"jemalloc		jemalloc	>=dev-libs/jemalloc-5.2.0[static-libs] \
		USE_INTERNAL_JEMALLOC_LIBRARY=no	USE_JEMALLOC		ENABLE_JEMALLOC"
	"fastops		fastops		fastops-${FASTOPS_COMMIT}.tar.gz \
		USE_INTERNAL_FASTOPS_LIBRARY=yes	USE_FASTOPS		ENABLE_FASTOPS"
	"libbtrie	-	-	USE_INTERNAL_BTRIE_LIBRARY=yes	USE_INTERNAL_BTRIE_LIBRARY"
	"libcpuid	-	-	USE_INTERNAL_CPUID_LIBRARY=yes	USE_CPUID"
	"libcxx			libcxx		>=sys-libs/libcxx-9.0.0[libcxxabi,static-libs] \
		USE_INTERNAL_LIBCXX_LIBRARY=no		HAVE_LIBCXX		USE_LIBCXX"
	"libcxxabi		libcxx		-\
		USE_INTERNAL_LIBCXXABI_LIBRARY=no	LIBCXXABI_LIBRARY"
	"libedit		libedit		dev-libs/libedit[static-libs] \
		USE_INTERNAL_LIBEDIT_LIBRARY=no		USE_LIBEDIT		ENABLE_READLINE"
	# libdivide
	"libfarmhash		-		- \
		USE_INTERNAL_FARMHASH_LIBRARY=yes	USE_INTERNAL_FARMHASH_LIBRARY"
	"libhdfs3		hdfs3		libhdfs3-${LIBHDFS3_COMMIT}.tar.gz \
		USE_INTERNAL_HDFS3_LIBRARY=yes		USE_HDFS		ENABLE_HDFS"
	"libmetrohash	-	-	USE_INTERNAL_METROHASH_LIBRARY=yes	USE_INTERNAL_METROHASH_LIBRARY"
	# libpcg-random
	"librdkafka		kafka		>=dev-libs/librdkafka-1.1.0:=[ssl?,lz4,static-libs] \
		USE_INTERNAL_RDKAFKA_LIBRARY=no		USE_RDKAFKA		ENABLE_RDKAFKA"
	"libsparsehash	-	-	USE_INTERNAL_SPARCEHASH_LIBRARY=yes	USE_INTERNAL_SPARCEHASH_LIBRARY"
	"libtcmalloc		tcmalloc	- \
		USE_INTERNAL_GPERFTOOLS_LIBRARY=yes	USE_TCMALLOC		ENABLE_TCMALLOC"
	"libunwind		libunwind	libunwind-${LIBUNWIND_COMMIT}.tar.gz \
		USE_INTERNAL_UNWIND_LIBRARY=yes		USE_UNWIND		USE_UNWIND"
	"libxml2		-		>=dev-libs/libxml2-2.9.8:=[static-libs] \
		USE_INTERNAL_LIBXML2_LIBRARY=no		MISSING_INTERNAL_LIBXML2_LIBRARY"
	"llvm			llvm		>=sys-devel/llvm-5.0.0:=[libedit?,static-libs(+)] \
		USE_INTERNAL_LLVM_LIBRARY=no		USE_EMBEDDED_COMPILER	ENABLE_EMBEDDED_COMPILER"
	"ltdl			odbc		dev-libs/libltdl:=[static-libs] \
		USE_INTERNAL_LTDL_LIBRARY=no		LTDL_LIBRARY"
	"lz4			-		>=app-arch/lz4-1.9.1:=[static-libs] \
		USE_INTERNAL_LZ4_LIBRARY=no		MISSING_INTERNAL_LZ4_LIBRARY"
	"mariadb-connector-c	mysql		- \
		USE_INTERNAL_MYSQL_LIBRARY=no		USE_MYSQL		ENABLE_MYSQL"
	"mongodb		mongodb		- \
		USE_INTERNAL_POCO_MONGODB=yes		USE_POCO_MONGODB	ENABLE_POCO_MONGODB"
	"orc			orc		apache-orc-${ORC_COMMIT}.tar.gz \
		USE_INTERNAL_ORC_LIBRARY=yes		USE_ORC			ENABLE_ORC"
	# pdqsort
	"poco			-		poco-${POCO_COMMIT}.tar.gz \
		USE_INTERNAL_POCO_LIBRARY=yes		USE_INTERNAL_POCO_LIBRARY"
	"protobuf		protobuf	>=dev-libs/protobuf-3.6.1:=[static-libs] \
		USE_INTERNAL_PROTOBUF_LIBRARY=no	USE_PROTOBUF		ENABLE_PROTOBUF"
	"rapidjson		json		rapidjson-${RAPIDJSON_COMMIT}.tar.gz \
		USE_INTERNAL_RAPIDJSON_LIBRARY=yes	USE_RAPIDJSON		ENABLE_RAPIDJSON"
	"readline		readline	sys-libs/readline:0=[static-libs] \
		USE_INTERNAL_READLINE_LIBRARY=no	USE_READLINE		ENABLE_READLINE"
	"snappy			parquet		snappy-${SNAPPY_COMMIT}.tar.gz \
		USE_INTERNAL_SNAPPY_LIBRARY=yes		USE_SNAPPY"
	"sparsehash-c11		-		sparsehash-c11-${SPARSEHASH_C11_COMMIT}.tar.gz \
		USE_INTERNAL_SPARSEHASH_LIBRARY=yes	USE_INTERNAL_SPARSEHASH_LIBRARY"
	"ssl			ssl		- \
		USE_INTERNAL_SSL_LIBRARY=no		USE_SSL			ENABLE_SSL"
	"thrift			parquet		thrift-${THRIFT_COMMIT}.tar.gz \
		USE_INTERNAL_THRIFT_LIBRARY=yes		THRIFT_LIBRARY"
	"unixodbc		odbc		dev-db/unixODBC[static-libs] \
		USE_INTERNAL_ODBC_LIBRARY=no		USE_ODBC		ENABLE_ODBC"
	"xxhash			-		dev-libs/xxhash[static-libs] \
		USE_INTERNAL_XXHASH_LIBRARY=no		USE_XXHASH"
	"zlib-ng		-		zlib-ng-${ZLIB_NG_COMMIT}.tar.gz \
		USE_INTERNAL_ZLIB_LIBRARY=yes		USE_INTERNAL_ZLIB_LIBRARY"
	"zstd			-		>=app-arch/zstd-1.3.4[lz4,static-libs] \
		USE_INTERNAL_ZSTD_LIBRARY=no		ZSTD_LIBRARY"
)

CLICKHOUSE_CMAKE_VENDORING=()
CLICKHOUSE_UNPACK_OR_REMOVE=()
CLICKHOUSE_CMAKE_USE_ARGUMENTS=()
CLICKHOUSE_CMAKE_CONFIG_CHECKS=()

CLICKHOUSE_VENDORING_HARDCODED=(
	USE_INTERNAL_BASE64_LIBRARY=yes
	USE_INTERNAL_FASTOPS_LIBRARY=yes
	USE_INTERNAL_ICU_LIBRARY=no
	USE_INTERNAL_LIBEDIT_LIBRARY=no
	USE_INTERNAL_LTDL_LIBRARY=no
	USE_INTERNAL_POCO_MONGODB=yes
	USE_INTERNAL_READLINE_LIBRARY=no
	USE_INTERNAL_UNWIND_LIBRARY=yes
)

DEPEND_GEN=""
RDEPEND_GEN=""
_clickhouse_setup_vars() {
	local line component use_flag src dyn internal check activate
	for line in "${CLICKHOUSE_DEPS[@]}"; do
		read -r component use_flag src internal check activate <<< "${line}"

		[[ "${src}" == "-" ]] && src=
		[[ "${use_flag}" == "-" ]] && use_flag=

		if [[ "${internal}" =~ ^.+=yes$ ]]; then
			[[ "${src}" ]] && CLICKHOUSE_UNPACK_OR_REMOVE+=( "${component}	${src}	${use_flag}" )
		else
			CLICKHOUSE_UNPACK_OR_REMOVE+=( "${component}" )
			dyn="${src/,static-libs(+)/}"
			dyn="${dyn/,static-libs/}"
			dyn="${dyn/static-libs(+)/}"
			dyn="${dyn/static-libs/}"
			dyn="${dyn/[]/}"

			if [[ "${use_flag}" && "${src}" ]]; then
				DEPEND_GEN+="		${use_flag}? ( ${src} )"
				RDEPEND_GEN+="		${use_flag}? ( ${dyn} )"
			elif [[ "${src}" ]]; then
				DEPEND_GEN+="		${src}"
				RDEPEND_GEN+="		${dyn}"
			fi
			DEPEND_GEN+=$'\n'
			RDEPEND_GEN+=$'\n'
		fi

		[[ ! " ${CLICKHOUSE_VENDORING_HARDCODED[@]} " =~ " ${internal} " ]] && \
			CLICKHOUSE_CMAKE_VENDORING+=( "${internal} ${use_flag}" )

		CLICKHOUSE_CMAKE_CONFIG_CHECKS+=( "${check} ${use_flag}" )

		if [[ "${activate}" ]]; then
			CLICKHOUSE_CMAKE_USE_ARGUMENTS+=( "${activate}	${use_flag}" )
		fi
	done
}

_clickhouse_setup_vars
DEPEND="${DEPEND_BASE}
	static? (
${DEPEND_GEN}	)
"
RDEPEND="${RDEPEND_BASE}
	!static? (
${RDEPEND_GEN}	)
"

LLVM_MAX_SLOT=7

CMAKE_BUILD_TYPE="Release"

pkg_setup() {
	use llvm && llvm_pkg_setup
}

pkg_pretend() {
	if ! use static; then
		ewarn "Non static builds are not supported by upstream."
	fi

	if use static && use '!static-libs'; then
		ewarn "Static linking is requested but static libraries linking is disabled. "
		ewarn "Statically linked shared libraries will be created."
		ewarn "Make sure dependencies are compiled with -fPIC."
	fi

	if tc-is-clang; then
		if [[ $(clang-major-version) -lt 7 ]]; then
			eerror "Compilation with clang older than 7.0 is not supported"
			die "Too old clang found"
		fi
	elif use libcxx; then
		eerror "Compilation with libcxx is only supported when using clang"
		die "Use clang to build with libcxx"
	elif [[ $(gcc-major-version) -lt 8 ]] && [[$(gcc-minor-version) -lt 1 ]]; then
		eerror "Compilation with gcc older than 8.1 is not supported"
		die "Too old gcc found"
	fi

	is-ldflagq "-flto" || ewarn "LTO (-flto) is not enabled in LDFLAGS. This is not recommended."
	tc-ld-is-lld || ewarn "Linking with linkers other than LLD is not recommended."
}

src_unpack() {
	default_src_unpack

	[[ "${PV}" == 9999 ]] && git-r3_src_unpack

	cd "${S}/contrib" || die "failed to cd to contrib"

	local unpack_or_remove line lib src use_flag

	unpack_or_remove=( "${CLICKHOUSE_UNPACK_OR_REMOVE[@]}" )

	unpack_or_remove+=(
		"re2		re2-${RE2_COMMIT}.tar.gz			static"
		"libgsasl	libgsasl-clickhouse-${LIBGSASL_COMMIT}.tar.gz	static"
	)

	if use json; then
		unpack_or_remove+=(
			"simdjson	simdjson-${SIMDJSON_COMMIT}.tar.gz	cpu_flags_x86_avx2"
		)
	else
		# just remove them
		unpack_or_remove+=(
			"simdjson	simdjson-${SIMDJSON_COMMIT}.tar.gz	json"
		)
	fi

	for line in "${unpack_or_remove[@]}"; do
		read -r lib src use_flag <<< "${line}"

		if [[ -z "${src}" ]] || { [[ "${use_flag}" ]] && ! use "${use_flag}"; }; then
			rm -v -rf "${lib}" || ewarn "Can't remove contrib/${lib}"
			continue
		fi

		[[ "${PV}" == 9999 ]] && continue

		einfo "Vendoring ${lib}: ${src}"
		mkdir -p "${lib}" || die "failed to create directory ${lib}"
		tar --strip-components=1 -C "${lib}" -xf "${DISTDIR}/${src}" || \
			die "failed to unpack ${lib}"
	done
}

src_prepare() {
	cmake-utils_src_prepare

	local component cmd lib

	# Fails if pattern was not found: mysed pattern replacement filename
	mysed() { sed -Ei "\\${4:-@}${1}${4:-@},\${s${4:-@}${4:-@}${2}${4:-@};b};\$q1" "${3}" || \
		die "Failed to find '${1}' in ${3}'" ; }

	mysed 'check_c_source_compile_or_run\($' 'message(Prevented check' contrib/zlib-ng/CMakeLists.txt
	mysed 'set\(CMAKE_C_FLAGS(.+)' 'set\(_CMAKE_C_FLAGS\1 # ebuild: user controls CFLAGS' \
		contrib/zlib-ng/CMakeLists.txt
	mysed '(HAVE_.+)_INTRIN' '\1' contrib/zlib-ng/CMakeLists.txt

	mysed '(set_source_files_properties.+|if.+|endif.+)' '# \1 # ebuild: user controls CFLAGS' \
		contrib/fastops-cmake/CMakeLists.txt
	if use fastops && use '!cpu_flags_x86_avx2'; then
		printf 'target_compile_definitions(fastops PUBLIC "-DNO_AVX2")\n' >> \
			 contrib/fastops-cmake/CMakeLists.txt
	fi

	if is-flagq '-fuse-ld*' || { ! tc-ld-is-lld && ! tc-ld-is-gold; }; then
		mysed 'if \(NOT LINKER_NAME\)' 'if \(FALSE\) # ebuild: disable linker auto-choosing' cmake/tools.cmake
	fi
	if use json && is-flag '-m*'; then
		echo 'set_target_properties(${SIMDJSON_LIBRARY} PROPERTIES COMPILE_FLAGS -mno-avx2)' >> \
			contrib/simdjson-cmake/CMakeLists.txt
	fi
	if use hdfs3; then
		mysed '-D_GLIBCXX_USE_CXX11_ABI=0' '' contrib/libhdfs3-cmake/CMakeLists.txt
	fi
	if use libcxx; then
		mysed '\$\{LIBCXXFS_LIBRARY}(.+)' '\1 # ebuild: fix libcxx-fs usage' cmake/find/cxx.cmake
		echo 'set_source_files_properties(src/Common/Dwarf.cpp PROPERTIES COMPILE_DEFINITIONS
			"_LIBCPP_ENABLE_NARROWING_CONVERSIONS_IN_VARIANT=1")' >> dbms/CMakeLists.txt
		use llvm && mysed 'if \(LLVM_FOUND AND OS_LINUX AND USE_LIBCXX\)' \
			'if(FALSE) # ebuild: system llvm build with system libc++' cmake/find/llvm.cmake
	fi
	if use '!static' && { use jemalloc || use tcmalloc; }; then
		lib="\${$(
			usex jemalloc JEMALLOC_LIBRARIES "$(
				usex debug GPERFTOOLS_TCMALLOC_MINIMAL_DEBUG GPERFTOOLS_TCMALLOC_MINIMAL
			)"
		)}"
		for component in dbms clickhouse_common_io; do
			echo "target_link_libraries(${component} PRIVATE ${lib})"
		done >> dbms/CMakeLists.txt

		echo "target_link_libraries(zookeeper-adjust-block-numbers-to-parts PRIVATE ${lib})" >> \
			utils/zookeeper-adjust-block-numbers-to-parts/CMakeLists.txt
		echo "target_link_libraries(convert-month-partitioned-parts PRIVATE ${lib})" >> \
			utils/convert-month-partitioned-parts/CMakeLists.txt
	fi
	if use kafka; then
		mysed 'list *\(APPEND +RDKAFKA_LIBRARY +\$\{LZ4_LIBRARY\}\)' '' cmake/find/rdkafka.cmake
		echo "target_link_libraries(cppkafka PRIVATE \${ZLIB_LIBRARIES})" >> \
			contrib/cppkafka-cmake/CMakeLists.txt || \
				die "Failed to fix cppkafka linking problems"
	fi
	if use libunwind; then
		mysed '((LIBRARY|ARCHIVE) +DESTINATION +lib)' '# \1' contrib/libunwind-cmake/CMakeLists.txt
	fi
	if use '!orc'; then
		mysed 'set\(USE_ORC +1\)' 'set(USE_ORC 0) # ebuild fix' cmake/find/parquet.cmake
		mysed '(configure_file *\("\$\{ORC.+)' '# ebuild fix \1' contrib/arrow-cmake/CMakeLists.txt
		mysed '(include.+orc.+cmake.*)' '# ebuild fix: \1' contrib/arrow-cmake/CMakeLists.txt
		mysed '(\$\{ORC_SRCS})' '# ebuild fix: \1' contrib/arrow-cmake/CMakeLists.txt
	fi
	if use parquet; then
		use '!static' && {
			mysed 'install\(EXPORT +\$\{PROJECT_NAME\}-targets' 'install(\${PROJECT_NAME}-targets/' \
				contrib/arrow/cpp/CMakeLists.txt
			mysed 'export\(EXPORT' 'message(Disabled EXPORT: ' contrib/arrow/cpp/CMakeLists.txt
		}
		mysed 'EXPORT SnappyTargets' '' contrib/snappy/CMakeLists.txt
		mysed 'install\($' 'message(Disabled install: ' contrib/snappy/CMakeLists.txt

		mysed 'add_dependencies\(\$\{ARROW_LIBRARY} protoc\)' '' contrib/arrow-cmake/CMakeLists.txt
		mysed 'set\(PROTOB.+' '' contrib/arrow-cmake/CMakeLists.txt
	fi
	if use '!static'; then
		mysed 'add_subdirectory *\(contrib +EXCLUDE_FROM_ALL\)' \
			'add_subdirectory (contrib) # ebuild enabled installs' CMakeLists.txt
		mysed '(set_property\(DIRECTORY PROPERTY EXCLUDE_FROM_ALL 1\))' \
			'message("Disabled: \1")' contrib/CMakeLists.txt

		echo 'install(TARGETS clickhouse_common_io COMPONENT clickhouse)' >> dbms/CMakeLists.txt
		echo "install(TARGETS dbms COMPONENT clickhouse LIBRARY DESTINATION \${CMAKE_INSTALL_LIBDIR}/${PN})" >> \
			dbms/CMakeLists.txt
		echo "install(TARGETS string_utils COMPONENT clickhouse LIBRARY DESTINATION \${CMAKE_INSTALL_LIBDIR}/${PN})" >> \
			dbms/src/Common/StringUtils/CMakeLists.txt
		echo "install(TARGETS apple_rt DESTINATION \${CMAKE_INSTALL_LIBDIR}/${PN})" >> \
			libs/libcommon/CMakeLists.txt
		use mysql && echo 'install(TARGETS mysqlxx COMPONENT clickhouse)' >> libs/libmysqlxx/CMakeLists.txt
		for component in 'daemon' common loggers memcpy widechar_width; do
			printf 'install(TARGETS %s DESTINATION ${CMAKE_INSTALL_LIBDIR}/%s)\n' "${component}" "${PN}" >> \
				"libs/lib${component}/CMakeLists.txt" || die "Failed to add install target: lib${component}"
		done
	fi
	if use '!static' && use static-libs; then
		for lib in Util Foundation; do
			printf 'target_compile_options(${LIBNAME} PRIVATE -fPIC)\n' >> \
				"contrib/poco/${lib}/CMakeLists.txt" || \
				die "Failed to add PIC to ${lib}"
		done
	fi
	if use '!static-libs'; then
		eapply "${FILESDIR}/zlib-ng-splitlib.patch"
		mysed '(add_library\(\$\{name\} SHARED .+)' \
			"\\1\ninstall(TARGETS \${name} COMPONENT clickhouse LIBRARY DESTINATION \${CMAKE_INSTALL_LIBDIR}/${PN})" \
			dbms/CMakeLists.txt
		mysed '(add_library\(clickhouse-\$\{name\}-lib .+)' \
			"\\1\n    install(TARGETS clickhouse-\${name}-lib COMPONENT clickhouse LIBRARY DESTINATION \${CMAKE_INSTALL_LIBDIR}/${PN})" \
			dbms/programs/CMakeLists.txt
	else
		eapply "${FILESDIR}/zlib-ng-nosplitlib.patch"
	fi

	if use doc; then
		cmd='4iimport codecs; open = lambda *args: codecs.open(*args, encoding="utf8")'
		sed -i "${cmd}" docs/tools/concatenate.py && \
		sed -i "${cmd}" docs/tools/util.py && \
		sed -i "${cmd}" docs/tools/test.py && \
		mysed "check_(call\(' '.join\(create_pdf.+)" '\1 # ebuild: ignore errors here (too heavy deps)' \
			docs/tools/build.py && \
		echo 'choose_latest_releases = None' > docs/tools/github.py && \
		echo 'build_releases = lambda *args, **kwargs: None' >> docs/tools/github.py || \
			die "Failed to prepare docs build tools"
	fi
	if use '!test'; then
		mysed '(add_subdirectory *\(tests\))' 'message("Disabled: \1")' dbms/CMakeLists.txt
	fi

	[[ "${PV}" == "9999" ]] && mkdir -p contrib/boost/boost

	local cmake_config_checks line cmake_var use_flag

	cmake_config_checks="${CLICKHOUSE_CMAKE_CONFIG_CHECKS[@]}"

	is-ldflagq "-flto" && cmake_config_checks+=( "CMAKE_INTERPROCEDURAL_OPTIMIZATION" )
	if use json; then
		cmake_config_checks+=( "USE_SIMDJSON cpu_flags_x86_avx2" )
	else
		cmake_config_checks+=( "USE_SIMDJSON json" )
	fi
	cmake_config_checks+=(
		"USE_INTERNAL_LIBGSASL_LIBRARY	static"
		"USE_LIBGSASL"
		"USE_INTERNAL_RE2_LIBRARY	static"
	)

	einfo "Creating additional configuration checks"

	# Add some checks to CMakeLists.txt to ensure that all the options are in desired state
	for line in "${CLICKHOUSE_CMAKE_CONFIG_CHECKS[@]}"; do
		read -r cmake_var use_flag <<< "${line}"
		printf 'if (%s%s)\n	message (FATAL_ERROR "Failed to %s%s: %s=${%s}")\nendif ()\n' "$(
			[[ "${use_flag}" ]] && usex "${use_flag}" 'NOT ' " " || printf 'NOT '
		)" "${cmake_var}" "$(
			[[ "${use_flag}" ]] && usex "${use_flag}" 'use ' 'disable ' || printf check
		)" "${use_flag}" "${cmake_var}" "${cmake_var}" >> CMakeLists.txt
	done

	for line in "${CLICKHOUSE_VENDORING_HARDCODED[@]}"; do
		{
			printf 'if (DEFINED %s)\n message (WARNING "%s,current=$%s) ' \
				"${line/=*/}" "${line/=/(}" "${line/=*/}"
			printf 'was not expected to be defined. Please review the config")\nendif()\n'
		} >> CMakeLists.txt
	done
}

src_configure() {
	local line mycmakeargs use_flag cmake_option cmake_var
	for line in \
		"SSE4.1: use=$(usex cpu_flags_x86_sse4_1), flags=$(is-flag "-msse4.1")" \
		"SSE4.2: use=$(usex cpu_flags_x86_sse4_2), flags=$(is-flag "-msse4.2")" \
		"SSSE3: use=$(usex cpu_flags_x86_ssse3), flags=$(is-flag "-mssse3")" \
		"AVX: use=$(usex cpu_flags_x86_avx), flags=$(is-flag "-mavx")" \
		"AVX2: use=$(usex cpu_flags_x86_avx2), flags=$(is-flag "-mavx2")" \
		"FMA3: use=$(usex cpu_flags_x86_fma3), flags=$(is-flag "-mfma")" \
		"PCLMUL: use=$(usex cpu_flags_x86_pclmul), flags=$(is-flag "-mpclmul")";
	do
		if [[ ! "${line}" =~ use=(yes,\ flags=true|no,\ flags=)$ ]]; then
			if is-flag '-march=*'; then
				elog "Can't check if CFLAGS are set in accordance with CPU_FLAGS_X86 (${line}). "\
					"This is probably OK as you have -march set."
			else
				ewarn "Can't check if CFLAGS are set in accordance with CPU_FLAGS_X86 (${line})."
			fi
		fi
	done

	if use ppc64; then
		append-cflags "-maltivec" "-D__SSE2__=1" "-DNO_WARN_X86_INTRINSICS"
		append-cxxflags "-maltivec" "-D__SSE2__=1" "-DNO_WARN_X86_INTRINSICS"
	fi
	if use static || use static-libs; then
		append-flags -Wa,--noexecstack
	fi

	mycmakeargs=(
		-D"CMAKE_LINKER"="$(tc-getLD)"
		-D"DISABLE_CPU_OPTIMIZE"="yes"
		-D"HAVE_SSE2"="$(usex cpu_flags_x86_sse2)"
		-D"HAVE_SSE41"="$(usex cpu_flags_x86_sse4_1)"
		-D"HAVE_SSE42"="$(usex cpu_flags_x86_sse4_2)"
		-D"HAVE_SSE42CRC"="$(usex cpu_flags_x86_sse4_2)"
		-D"HAVE_SSSE3"="$(usex cpu_flags_x86_ssse3)"
		-D"HAVE_AVX"="$(usex cpu_flags_x86_avx)"
		-D"HAVE_AVX2"="$(usex cpu_flags_x86_avx2)"
		-D"HAVE_PCLMULQDQ"="$(usex cpu_flags_x86_pclmul)"

		-D"USE_INTERNAL_LIBGSASL_LIBRARY"="$(usex static)"
		-D"USE_INTERNAL_RE2_LIBRARY"="$(usex static)"
	)
	use parquet && mycmakeargs+=( -D"PROTOBUF_EXECUTABLE"=protoc )

	for line in "${CLICKHOUSE_CMAKE_USE_ARGUMENTS[@]}"; do
		read -r cmake_option use_flag <<< "${line}"
		mycmakeargs+=( "-D${cmake_option}=$(
			[[ ${use_flag} ]] && usex "${use_flag}" || printf yes
		)" )
	done

	mycmakeargs+=(
		-D"BUILD_SHARED_LIBS"="$(usex !static-libs)"
		-D"SPLIT_SHARED_LIBRARIES"="$(usex !static-libs)"
		-D"USE_STATIC_LIBRARIES"="$(usex static)"
		-D"MAKE_STATIC_LIBRARIES"="$(usex static-libs)"
		-D"CLICKHOUSE_SPLIT_BINARY"="$(usex split-binary)"

		-D"ENABLE_IPO"="$(is-ldflagq "-flto" && printf yes || printf no)"

		-D"ENABLE_TESTS"="$(usex test)"
		-D"ENABLE_CODE_QUALITY"="$(usex test)"
		-D"WITH_COVERAGE"="$(usex test)"

		-D"ENABLE_CLICKHOUSE_ALL"="$(usex tools)"
		-D"ENABLE_CLICKHOUSE_SERVER"="$(usex server)"
		-D"ENABLE_CLICKHOUSE_CLIENT"="$(usex client)"
		-D"ENABLE_CLICKHOUSE_ODBC_BRIDGE"="$(usex odbc "$(usex tools)" no)"
		-D"ENABLE_UTILS"="$(usex tools)"

		# setting it to "yes" breaks configuration process because
		# ClickHouse is not trying to set up link targets and other
		# compile options even when this is "yes"
		-D"UNBUNDLED"="no"
		-D"NO_WERROR"="$(is-flagq -Werror && printf no || printf yes)"

		-D"DISABLE_INTERNAL_OPENSSL"="yes"
		-D"ENABLE_POCO_NETSSL"="$(usex ssl)"

		-D"USE_INTERNAL_SSL_LIBRARY"="no"
		-D"USE_INTERNAL_RE2_LIBRARY"="$(usex static)"

		-D"USE_SIMDJSON"="$(usex json $(usex 'cpu_flags_x86_avx2') no)"
	)
	if is-flagq '-fuse-ld*'; then
		mycmakeargs+=( -D"LINKER_NAME"="" )
	elif tc-is-clang; then
		is-flagq '-fuse-ld*' || append-flags "-fuse-ld=$(command -v "$(tc-getLD)")"
		mycmakeargs+=( -D"LINKER_NAME"="$(command -v "$(tc-getLD)")" )
	elif tc-ld-is-lld; then
		mycmakeargs+=( -D"LINKER_NAME"=lld )
	elif tc-ld-is-gold; then
		mycmakeargs+=( -D"LINKER_NAME"=gold )
	else
		mycmakeargs+=( -D"LINKER_NAME"="" )
	fi
	if use '!server' && use '!client' && use '!tools'; then
		mycmakeargs+=( -D"ENABLE_CLICKHOUSE_LOCAL"="yes" )
	fi
	if use '!static'; then
		mycmakeargs+=(
			-D"CMAKE_SKIP_BUILD_RPATH"="no"
			-D"CMAKE_SKIP_INSTALL_RPATH"="no"
			-D"CMAKE_BUILD_WITH_INSTALL_RPATH"="yes"
			-D"CMAKE_INSTALL_RPATH"="/usr/$(get_libdir)/${PN}/"
			-D"CMAKE_INSTALL_RPATH_USE_LINK_PATH"="no"
		)
	fi

	for line in "${CLICKHOUSE_CMAKE_VENDORING[@]}"; do
		read -r cmake_option use_flag <<< "${line}"
		[[ "${use_flag}" ]] && use "!${use_flag}" && cmake_option=
		[[ "${cmake_option}" ]] && mycmakeargs+=( -D"${cmake_option}" )
	done

	if use llvm; then
		mycmakeargs+=( -D"LLVM_VERSION"="$("$(get_llvm_prefix -b "${LLVM_MAX_SLOT}")"/bin/llvm-config --version)" )
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc; then
		cd docs/tools || die "Failed to enter docs build directory"
		./build.py --verbose || die "Failed to build docs"
	fi
}

src_install() {
	cmake-utils_src_install

	local file

	if ! use test; then
		rm -v "${D}/usr/bin/clickhouse-"*test*
		rm -rf "${D}/usr/share/clickhouse-test" || die "failed to remove tests"
	fi

	if use doc; then
		dodoc -r "${S}/docs/build"
	fi

	if use server; then
		newinitd "${FILESDIR}/clickhouse-server.initd" clickhouse-server
		systemd_dounit "${FILESDIR}/clickhouse-server.service"
	fi

	if use tools; then
		mkdir -p "${D}/usr/libexec/clickhouse/"
		ln -sr "${D}/usr/libexec/clickhouse/" "${D}/usr/libexec/clickhouse/bin"
		into "/usr/libexec/clickhouse"
		for file in $(find "${BUILD_DIR}/utils/" -perm -755 -type f); do
			dobin ${file}
		done
		into "/usr"
		rm "${D}/usr/libexec/clickhouse/bin"
	fi

	if ! use static; then
		for file in $(
			find "${BUILD_DIR}/"{dbms/src,dbms/programs/client/r*,contrib,libs/co*} \
				! -name '*libz-ng*' ! -name '*snappy*' ! -name '*string_*' -name '*.so*' || \
					die "No additional libraries to install"
		); do
			dolib.so "${file}"
		done
	fi

	if use server; then
		keepdir "/var/log/clickhouse-server"
		keepdir "/var/lib/clickhouse"
	fi
}

pkg_preinst() {
	if use server; then
		chown clickhouse:clickhouse "${D}/var/log/clickhouse-server" "${D}/var/lib/clickhouse"
	fi
}
