# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit cmake-multilib python-any-r1 toolchain-funcs

DESCRIPTION="C++ HTTP/HTTPS server and client library"
HOMEPAGE="https://github.com/yhirose/cpp-httplib/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/yhirose/${PN}.git"
else
	SRC_URI="https://github.com/yhirose/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="MIT"
SLOT="0/$(ver_cut 0-2)"  # soversion

IUSE="brotli mbedtls ssl test zlib zstd"
REQUIRED_USE="test? ( brotli zlib zstd )"
RESTRICT="!test? ( test )"

RDEPEND="
	brotli? (
		app-arch/brotli:=[${MULTILIB_USEDEP}]
	)
	ssl? (
		mbedtls? ( net-libs/mbedtls:3=[${MULTILIB_USEDEP}] )
		!mbedtls? ( >=dev-libs/openssl-3.0.13:=[${MULTILIB_USEDEP}] )
	)
	zlib? (
		virtual/zlib:=[${MULTILIB_USEDEP}]
	)
	zstd? (
		app-arch/zstd[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/gtest
		dev-libs/openssl
		net-misc/curl
	)
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/cpp-httplib-0.32.0-cmake-mbedtls.patch"
)

src_configure() {
	local -a mycmakeargs=(
		-DHTTPLIB_COMPILE=yes
		-DHTTPLIB_SHARED=yes
		-DHTTPLIB_USE_BROTLI_IF_AVAILABLE=no
		-DHTTPLIB_USE_OPENSSL_IF_AVAILABLE=no
		-DHTTPLIB_USE_MBEDTLS_IF_AVAILABLE=no
		-DHTTPLIB_USE_ZLIB_IF_AVAILABLE=no
		-DHTTPLIB_USE_ZSTD_IF_AVAILABLE=no
		-DHTTPLIB_REQUIRE_BROTLI=$(usex brotli)
		-DHTTPLIB_REQUIRE_OPENSSL=$(usex ssl $(usex mbedtls no yes))
		-DHTTPLIB_REQUIRE_MBEDTLS=$(usex ssl $(usex mbedtls))
		-DHTTPLIB_REQUIRE_ZLIB=$(usex zlib)
		-DHTTPLIB_REQUIRE_ZSTD=$(usex zstd)
		-DPython3_EXECUTABLE="${PYTHON}"
	)
	cmake-multilib_src_configure
}

multilib_src_test() {
	if [[ ${ABI} == x86 ]]; then
		ewarn "Upstream no longer supports 32 bits:"
		ewarn https://github.com/yhirose/cpp-httplib/issues/2148
		return
	fi

	cp -p -R --reflink=auto "${S}/test" ./test || die

	local -a failing_tests=(
		# Disable all online tests.
		"*.*_Online"
	)

	# Little dance to please the GTEST filter (join array using ":").
	failing_tests_str="${failing_tests[@]}"
	failing_tests_filter="${failing_tests_str// /:}"

	# PREFIX is . to avoid calling "brew" and relying on stuff in /opt
	GTEST_FILTER="-${failing_tests_filter}" emake -C test \
		CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS} -I." PREFIX=.
}
