# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit meson-multilib python-any-r1

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
REQUIRED_USE="test? ( ssl )"
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
BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/cpp-httplib-0.31.0-mbedtls.patch
	"${FILESDIR}"/cpp-httplib-0.31.0-mbedtls-3.patch
)

src_prepare() {
	default
	rm -r test/gtest || die
}

src_configure() {
	local emesonargs=(
		-Dcompile=true
		$(meson_feature zlib)
		$(meson_feature zstd)
		$(meson_feature brotli)
		$(meson_feature ssl)
		$(usex mbedtls -Dssl_backend=mbedtls -Dssl_backend=openssl)
		$(meson_use test)
	)
	meson-multilib_src_configure
}

multilib_src_test() {
	if [[ ${ABI} == x86 ]]; then
		ewarn "Upstream no longer supports 32 bits:"
		ewarn https://github.com/yhirose/cpp-httplib/issues/2148
		return
	fi

	local -a failing_tests=(
		# Disable all online tests.
		"*.*_Online"
		# https://github.com/yhirose/cpp-httplib/issues/2351
		SSLClientTest.UpdateCAStoreWithPem
	)

	# Little dance to please the GTEST filter (join array using ":").
	local failing_tests_str="${failing_tests[@]}"
	local failing_tests_filter="${failing_tests_str// /:}"

	GTEST_FILTER="-${failing_tests_filter}" meson_src_test
}
