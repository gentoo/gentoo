# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multiprocessing

DESCRIPTION="High performance C++ OpenPGP library"
HOMEPAGE="https://www.rnpgp.org/ https://github.com/rnpgp/rnp"
SRC_URI="https://github.com/rnpgp/rnp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/*lib/}"

LICENSE="Apache-2.0 BSD BSD-2"
SLOT="0/0.18.0"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~x86"

IUSE="+botan man test"
RESTRICT="!test? ( test )"

RDEPEND="app-arch/bzip2
	dev-libs/json-c:=
	>=dev-libs/sexpp-0.8.7
	sys-libs/zlib
	botan? ( dev-libs/botan:3= )
	!botan? ( >=dev-libs/openssl-1.1.1:= )"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
BDEPEND="man? ( dev-ruby/asciidoctor )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test on off)

		-DCRYPTO_BACKEND=$(usex botan botan3 openssl)

		-DDOWNLOAD_GTEST=off

		-DENABLE_COVERAGE=off
		-DENABLE_DOC=$(usex man on off)
		-DENABLE_FUZZERS=off
		-DENABLE_SANITIZERS=off

		-DSYSTEM_LIBSEXPP=on
	)

	if use botan; then
		local mycmakeargs+=(
			-DENABLE_AEAD=on
			-DENABLE_BLOWFISH=on
			-DENABLE_BRAINPOOL=on
			-DENABLE_CAST5=on
			-DENABLE_CRYPTO_REFRESH=on
			-DENABLE_IDEA=on
			-DENABLE_PQC=on
			-DENABLE_RIPEMD160=on
			-DENABLE_SM2=on
			-DENABLE_TWOFISH=on
		)

	# OpenSSL support is still not as complete as botan.
	# https://github.com/rnpgp/rnp/issues/1877 SM2,
	# https://github.com/openssl/openssl/issues/2046 TWOFISH (won't be implemented).
	# CRYPTO_REFRESH is experimental in 0.18.0 and PQC requires botan.
	else
		local mycmakeargs+=(
			-DENABLE_AEAD=on
			-DENABLE_BLOWFISH=on
			-DENABLE_BRAINPOOL=on
			-DENABLE_CAST5=on
			-DENABLE_CRYPTO_REFRESH=off
			-DENABLE_IDEA=on
			-DENABLE_PQC=off
			-DENABLE_RIPEMD160=on
			-DENABLE_SM2=off
			-DENABLE_TWOFISH=off
		)
	fi

	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}"/src/tests || die
	ctest -j$(makeopts_jobs) -R .* --output-on-failure || die
}

src_install() {
	cmake_src_install
	find "${D}" -name '*.a' -delete || die
}
