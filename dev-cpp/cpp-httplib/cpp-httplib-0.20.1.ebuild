# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit cmake-multilib python-any-r1 toolchain-funcs

DESCRIPTION="C++ HTTP/HTTPS server and client library"
HOMEPAGE="https://github.com/yhirose/cpp-httplib/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/yhirose/${PN}.git"
else
	SRC_URI="https://github.com/yhirose/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

LICENSE="MIT"
SLOT="0/0.20"  # soversion / /usr/include/httplib.h: CPPHTTPLIB_VERSION

IUSE="brotli ssl test zlib zstd"
RESTRICT="!test? ( test )"

RDEPEND="
	brotli? (
		app-arch/brotli:=[${MULTILIB_USEDEP}]
	)
	ssl? (
		>=dev-libs/openssl-3.0.13:=[${MULTILIB_USEDEP}]
	)
	zlib? (
		sys-libs/zlib[${MULTILIB_USEDEP}]
	)
	zstd? (
		app-arch/zstd[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

src_configure() {
	local -a mycmakeargs=(
		-DHTTPLIB_COMPILE=yes
		-DBUILD_SHARED_LIBS=yes
		-DHTTPLIB_USE_BROTLI_IF_AVAILABLE=no
		-DHTTPLIB_USE_OPENSSL_IF_AVAILABLE=no
		-DHTTPLIB_USE_ZLIB_IF_AVAILABLE=no
		-DHTTPLIB_USE_ZSTD_IF_AVAILABLE=no
		-DHTTPLIB_REQUIRE_BROTLI=$(usex brotli)
		-DHTTPLIB_REQUIRE_OPENSSL=$(usex ssl)
		-DHTTPLIB_REQUIRE_ZLIB=$(usex zlib)
		-DHTTPLIB_REQUIRE_ZSTD=$(usex zstd)
		-DPython3_EXECUTABLE="${PYTHON}"
	)
	cmake-multilib_src_configure
}

multilib_src_test() {
	cp -p -R --reflink=auto "${S}/test" ./test || die

	local -a failing_tests=(
		# Disable all online tests.
		"*.*_Online"

		# Fails on musl x86:
		ServerTest.GetRangeWithMaxLongLength
		ServerTest.GetStreamedWithTooManyRanges
	)

	# Little dance to please the GTEST filter (join array using ":").
	failing_tests_str="${failing_tests[@]}"
	failing_tests_filter="${failing_tests_str// /:}"

	# PREFIX is . to avoid calling "brew" and relying on stuff in /opt
	GTEST_FILTER="-${failing_tests_filter}" emake -C test \
		CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS} -I." PREFIX=.
}
