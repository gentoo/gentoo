# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Reference implementation of the Russian GOST crypto algorithms for OpenSSL"
HOMEPAGE="https://github.com/gost-engine/engine"
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gost-engine/engine.git"
else
	KEYWORDS="~amd64 ~hppa"
	SRC_URI="https://github.com/gost-engine/engine/releases/download/v${PV}/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/engine-${PV}"
fi

# libprov is linked in statically
LICENSE="Apache-2.0 CC0-1.0"
SLOT="0/${PV}"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=">=dev-libs/openssl-3.4:0="
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-lang/perl )"

DOCS=( INSTALL.md README.gost README.md README.prov.md )

src_prepare() {
	if [[ ${PV} != "9999" ]] ; then
		cp -R "${WORKDIR}/libprov-${LIBPROV_COMMIT}/." "${S}/libprov" || die
	fi
	cmake_src_prepare
	sed 's:Werror:Wno-error:g' -i "${S}/CMakeLists.txt" || die
}

src_configure() {
	local mycmakeargs=(
		-DOPENSSL_ROOT_DIR="${ESYSROOT}/usr"
		# OpenSSL 4 removed the ENGINE API, use the provider only
		-DGOST_BUILD_ENGINE=OFF
		# only used to install the engine, but CMakeLists.txt requires it
		-DOPENSSL_ENGINES_DIR=unused
	)
	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# needs libcrypto patched with patches/pkcs12/, see README.pkcs12.md
		test_pkcs12_rfc9337-with-provider
	)
	cmake_src_test
}
