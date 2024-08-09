# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Implementation of the 3D Manufacturing Format file standard"
HOMEPAGE="https://3mf.io/ https://github.com/3MFConsortium/lib3mf"
SRC_URI="https://github.com/3MFConsortium/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE="+system-act test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libzip:=
	sys-apps/util-linux
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	system-act? ( dev-go/act )
	test? (
		dev-cpp/gtest
		dev-libs/openssl
		dev-debug/valgrind
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0-0001-Gentoo-specific-avoid-pre-stripping-library.patch
	"${FILESDIR}"/${P}-0001-use-system-provided-act-binary.patch
	"${FILESDIR}"/${P}-0002-Gentoo-specific-remove-add_dependencies.patch
	"${FILESDIR}"/${P}-0001-remove-std-and-opt-flags.patch
	"${FILESDIR}"/${P}-include-cstdint.patch
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR="include/${PN}"
		-DLIB3MF_TESTS=$(usex test)
		-DUSE_INCLUDED_LIBZIP=OFF
		-DUSE_INCLUDED_ZLIB=OFF
		-DUSE_SYSTEM_ACT=$(usex system-act)
	)

	if use test; then
		mycmakeargs+=(
			-DUSE_INCLUDED_GTEST=OFF
			# code says it uses libressl, but works with openssl too
			-DUSE_INCLUDED_SSL=OFF
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	for suf in abi types implicit; do
		dosym -r /usr/include/${PN}/Bindings/Cpp/${PN}_${suf}.hpp /usr/include/${PN}/${PN}_${suf}.hpp
	done
}
