# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils systemd toolchain-funcs user

DESCRIPTION="An OSS column-oriented database management system for real-time data analysis"
HOMEPAGE="https://clickhouse.yandex"
LICENSE="Apache-2.0"

MY_PN="ClickHouse"
TYPE="stable"

CCTZ_COMMIT="4f9776a"
LIBRDKAFKA_COMMIT="c3d50eb"
LZ4_COMMIT="c10863b"
ZSTD_COMMIT="2555975"
SRC_URI="https://github.com/yandex/${MY_PN}/archive/v${PV}-${TYPE}.tar.gz -> ${P}.tar.gz
	https://github.com/google/cctz/archive/${CCTZ_COMMIT}.tar.gz -> cctz-${CCTZ_COMMIT}.tar.gz
	https://github.com/edenhill/librdkafka/archive/${LIBRDKAFKA_COMMIT}.tar.gz -> librdkafka-${LIBRDKAFKA_COMMIT}.tar.gz
	https://github.com/lz4/lz4/archive/${LZ4_COMMIT}.tar.gz -> lz4-${LZ4_COMMIT}.tar.gz
	https://github.com/facebook/zstd/archive/${ZSTD_COMMIT}.tar.gz -> zstd-${ZSTD_COMMIT}.tar.gz
"

SLOT="0/${TYPE}"
IUSE="+client cpu_flags_x86_sse4_2 +server debug doc kafka mongodb mysql static test tools zookeeper"
KEYWORDS="~amd64"

REQUIRED_USE="
	server? ( cpu_flags_x86_sse4_2 )
	static? ( client server tools )
"

RDEPEND="
	client? (
		sys-libs/ncurses:0
		sys-libs/readline:0
	)

	!static? (
		dev-libs/double-conversion
		dev-libs/capnproto
		dev-libs/libltdl:0
		sys-libs/zlib
		|| (
			dev-db/unixODBC
			dev-libs/poco[odbc]
		)
		dev-libs/icu:=
		dev-libs/glib
		dev-libs/boost:=
		dev-libs/openssl:0=
		dev-libs/zookeeper-c
		mysql? ( virtual/libmysqlclient )
	)

	>=dev-libs/poco-1.9.0
	dev-libs/libpcre
"

DEPEND="${RDEPEND}
	doc? ( >=dev-python/mkdocs-0.17.3 )
	static? (
		dev-libs/double-conversion[static-libs]
		dev-libs/capnproto[static-libs]
		dev-libs/libltdl[static-libs]
		sys-libs/zlib[static-libs]
		|| (
			dev-db/unixODBC[static-libs]
			dev-libs/poco[odbc]
		)
		dev-libs/icu[static-libs]
		dev-libs/glib[static-libs]
		dev-libs/boost[static-libs]
		dev-libs/openssl[static-libs]
		dev-libs/zookeeper-c[static-libs]
		virtual/libmysqlclient[static-libs]
	)

	sys-libs/libtermcap-compat
	dev-util/patchelf
	|| (
		>=sys-devel/gcc-7.0
		>=sys-devel/clang-6.0
	)
"

PATCHES=( ${FILESDIR}/clickhouse-concatenate-python3.patch )
S="${WORKDIR}/${MY_PN}-${PV}-${TYPE}"

_clang_fullversion() {
	local ver="$1"; shift
	set -- $($(tc-getCPP "$@") -E -P - <<<"__clang_major__ __clang_minor__ __clang_patchlevel__")
	eval echo "$ver"
}

clang-fullversion() {
	_clang_fullversion '$1.$2.$3' "$@"
}

clang-version() {
	_clang_fullversion '$1.$2' "$@"
}

clang-major-version() {
	_clang_fullversion '$1' "$@"
}

clang-minor-version() {
	_clang_fullversion '$2' "$@"
}

clang-micro-version() {
	_clang_fullversion '$3' "$@"
}

pkg_pretend() {
	if [[ $(tc-getCC) == clang ]]; then
		if [[ $(clang-major-version) -lt 6 ]]; then
			eerror "Compilation with clang older than 6.0 is not supported"
			die "Too old clang found"
		fi
		:
	elif [[ $(gcc-major-version) -lt 7 ]] && [[$(gcc-minor-version) -lt 2 ]]; then
		eerror "Compilation with gcc older than 7.2 is not supported"
		die "Too old gcc found"
	fi
}

src_unpack() {
	default_src_unpack
	[[ ${PV} == 9999 ]] && return 0
	cd "${S}/contrib" || die "failed to cd to contrib"
	mkdir -p cctz librdkafka lz4 zookeeper zstd || die "failed to create directories"
	tar --strip-components=1 -C cctz -xf "${DISTDIR}/cctz-${CCTZ_COMMIT}.tar.gz" || die "failed to unpack cctz"
	tar --strip-components=1 -C librdkafka -xf "${DISTDIR}/librdkafka-${LIBRDKAFKA_COMMIT}.tar.gz" || die "failed to unpack librdkafka"
	tar --strip-components=1 -C lz4 -xf "${DISTDIR}/lz4-${LZ4_COMMIT}.tar.gz" || die "failed to unpack lz4"
	tar --strip-components=1 -C zstd -xf "${DISTDIR}/zstd-${ZSTD_COMMIT}.tar.gz" || die "failed to unpack zstd"
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_POCO_MONGODB="$(usex mongodb)"
		-DENABLE_TESTS="$(usex test)"
		-DUSE_STATIC_LIBRARIES="$(usex static)"
		-DMAKE_STATIC_LIBRARIES="$(usex static)"
		-DUSE_MYSQL="$(usex mysql)"
		-DENABLE_CLICKHOUSE_SERVER="$(usex server)"
		-DENABLE_CLICKHOUSE_CLIENT="$(usex client)"
		-DENABLE_CLICKHOUSE_LOCAL="$(usex tools)"
		-DENABLE_CLICKHOUSE_BENCHMARK="$(usex tools)"
		-DENABLE_CLICKHOUSE_PERFORMANCE="$(usex tools)"
		-DENABLE_CLICKHOUSE_TOOLS="$(usex tools)"
		-DENABLE_CLICKHOUSE_COPIER="$(usex tools)"
		-DENABLE_CLICKHOUSE_ALL=OFF
		-DUSE_INTERNAL_CITYHASH_LIBRARY=ON # Clickhouse explicitly requires bundled patched cityhash
		-DUNBUNDLED=ON
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if ! use test; then
		rm -rf "${D}/usr/share/clickhouse-test" || die "failed to remove tests"
	fi

	if use doc; then
		pushd "${S}/docs" || die "Failed to enter docs build directory"
		./build.sh || die "Failed to build docs"
		popd || die "Failed to exit docs build directory"

		dodoc -r "${S}/docs/build/docs"
	fi

	if use server; then
		newinitd "${FILESDIR}"/clickhouse-server.initd clickhouse-server
		systemd_dounit "${FILESDIR}"/clickhouse-server.service
	fi
}

pkg_preinst() {
	if use server; then
		enewgroup clickhouse
		enewuser clickhouse -1 -1 /var/lib/clickhouse clickhouse
	fi
}
