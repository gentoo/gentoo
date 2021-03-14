# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake eapi8-dosym

DESCRIPTION="Implementation of the 3D Manufacturing Format file standard"
HOMEPAGE="https://3mf.io/ https://github.com/3MFConsortium/lib3mf"
SRC_URI="https://github.com/3MFConsortium/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/2"
# the included ACT binary is a statically x86_64 built one
# see https://github.com/3MFConsortium/lib3mf/issues/199
# no package available for ACT yet in Gentoo.
# Keywords x86 and arm64 can be re-added after we have a package
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libzip:=
	sys-apps/util-linux
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-cpp/gtest
		dev-libs/openssl
		dev-util/valgrind
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0-0001-Gentoo-specific-avoid-pre-stripping-library.patch
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR="include/${PN}"
		-DLIB3MF_TESTS=$(usex test)
		-DUSE_INCLUDED_LIBZIP=OFF
		-DUSE_INCLUDED_ZLIB=OFF
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
		dosym8 -r /usr/include/${PN}/Bindings/Cpp/${PN}_${suf}.hpp /usr/include/${PN}/${PN}_${suf}.hpp
	done
}
