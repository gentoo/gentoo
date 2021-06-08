# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PV="${PV//_pre/-pre}"

DESCRIPTION="Modern open source high performance RPC framework"
HOMEPAGE="https://www.grpc.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="doc examples"

DEPEND="
	=dev-cpp/abseil-cpp-20200225*:=
	>=dev-libs/protobuf-3.11.2:=
	>=net-dns/c-ares-1.15.0:=
	sys-libs/zlib:=
	>=dev-libs/openssl-1.0.2:0=[-bindist]
"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

# requires git checkouts of google tools
RESTRICT="test"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	cmake_src_prepare

	# un-hardcode libdir
	sed -i "s@lib/pkgconfig@$(get_libdir)/pkgconfig@" CMakeLists.txt || die
	sed -i "s@/lib@/$(get_libdir)@" cmake/pkg-config-template.pc.in || die
}

src_configure() {
	local mycmakeargs=(
		-DgRPC_INSTALL=ON
		-DgRPC_ABSL_PROVIDER=package
		-DgRPC_CARES_PROVIDER=package
		-DgRPC_INSTALL_CMAKEDIR="$(get_libdir)/cmake/${PN}"
		-DgRPC_INSTALL_LIBDIR="$(get_libdir)"
		-DgRPC_PROTOBUF_PROVIDER=package
		-DgRPC_SSL_PROVIDER=package
		-DgRPC_ZLIB_PROVIDER=package
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use examples; then
		find examples -name '.gitignore' -delete || die
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	if use doc; then
		find doc -name '.gitignore' -delete || die
		local DOCS=( AUTHORS CONCEPTS.md README.md TROUBLESHOOTING.md doc/. )
	fi

	einstalldocs
}
