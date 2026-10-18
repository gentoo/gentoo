# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Implementation of the 3D Manufacturing Format file standard"
HOMEPAGE="https://3mf.io/ https://github.com/3MFConsortium/lib3mf"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/3MFConsortium/lib3mf.git"
else
	SRC_URI="
		https://github.com/3MFConsortium/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

LICENSE="BSD"
SLOT="0/$(ver_cut 1)"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/fast_float
	dev-libs/libzip:=
	virtual/zlib:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-cpp/gtest
		dev-libs/openssl
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.5.0-remove-std-and-opt-flags.patch"
)

src_prepare() {
	# DO NOT WANT!
	rm -r Libraries/libressl || die

	# DO NOT WANT!
	rm -r SDK || die
	rm -r AutomaticComponentToolkit || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR="${EPREFIX}/usr/include/${PN}"
		-DLIB3MF_TESTS=$(usex test)
		-DUSE_INCLUDED_FASTFLOAT=OFF
		-DUSE_INCLUDED_LIBZIP=OFF
		-DUSE_INCLUDED_ZLIB=OFF
		-DUSE_INCLUDED_CPPBASE64=ON # TODO not packaged
		-DSTRIP_BINARIES=OFF
		-DLIB3MF_BUILD_WASM=OFF
		# we don't want valgrind tests
		-DVALGRIND=NOTFOUND
	)

	if use test; then
		mycmakeargs+=(
			# code says it uses libressl, but works with openssl too
			-DUSE_INCLUDED_SSL=OFF
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	for suf in abi types implicit; do
		dosym -r "/usr/include/${PN}/Bindings/Cpp/${PN}_${suf}.hpp" "/usr/include/${PN}/${PN}_${suf}.hpp"
	done
}
