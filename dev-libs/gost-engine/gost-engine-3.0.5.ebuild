# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A reference implementation of the Russian GOST crypto algorithms for OpenSSL"
HOMEPAGE="https://github.com/gost-engine/engine"

# libprov is linked in statically
LICENSE="Apache-2.0 CC0-1.0"
SLOT="0/${PV}"
IUSE="test"
RESTRICT="!test? ( test )"

COMMON_DEPEND=">=dev-libs/openssl-3.4:0="
DEPEND="${COMMON_DEPEND}
	test? (
		dev-lang/perl
	)"
RDEPEND="${COMMON_DEPEND}"

DOCS=( INSTALL.md README.gost README.md README.prov.md )

LIBPROV_COMMIT="d5d381f71c90fe0c91f861784b715b189554f1f2"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/gost-engine/engine.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~hppa"
	SRC_URI="https://github.com/gost-engine/engine/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/provider-corner/libprov/archive/${LIBPROV_COMMIT}.tar.gz -> libprov-${LIBPROV_COMMIT}.tar.gz"
	S="${WORKDIR}/engine-${PV}"
fi

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
