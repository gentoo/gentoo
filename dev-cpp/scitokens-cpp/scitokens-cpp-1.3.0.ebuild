# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scitokens/scitokens-cpp"
else
	SRC_URI="https://github.com/scitokens/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="C++ implementation of the SciTokens library with a C library interface"
HOMEPAGE="https://scitokens.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

DEPEND="
	>=dev-cpp/jwt-cpp-0.7.0[picojson]
	dev-db/sqlite
	dev-libs/openssl:0=
	net-misc/curl:0=
	kernel_linux? ( sys-apps/util-linux )
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-cpp/gtest )
"
RESTRICT="!test? ( test )"

src_prepare() {
	# Unbundle dev-cpp/gtest, dev-cpp/jwt-cpp
	rm -r vendor || die
	# Fix include path for picojson.
	find test/ src/ \( -name '*.cpp' -o -name '*.h' \) -type f -print0 | \
		xargs -0 sed -r -e "s:picojson/picojson\.h:picojson.h:g" -i || die
	# Disable network-based tests relying on external services.
	if use test; then
		sed -i	-e '/^TEST_F/s#RefreshTest#DISABLED_RefreshTest#' \
			-e '/^TEST_F/s#RefreshExpiredTest#DISABLED_RefreshExpiredTest#' \
			-e '/^TEST_F/s#LoadJwksTriggersRefreshWhenStale#DISABLED_LoadJwksTriggersRefreshWhenStale#' \
			-e '/^TEST_F/s#NegativeCacheTest#DISABLED_NegativeCacheTest#' \
			test/main.cpp || die
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSCITOKENS_BUILD_UNITTESTS="$(usex test)"
		-DSCITOKENS_EXTERNAL_GTEST=YES
	)
	cmake_src_configure
}
