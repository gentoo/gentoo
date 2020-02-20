# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="gRPC and Protobuf generator and bindings for Qt framework"
HOMEPAGE="https://semlanik.github.io/qtprotobuf/"
SRC_URI="https://github.com/semlanik/${PN}/archive/0.2.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/go-1.10
	>=dev-libs/protobuf-3.6:=
	>=dev-qt/qtcore-5.12.3
	>=dev-qt/qtnetwork-5.12.3
	>=dev-qt/qtdeclarative-5.12.3"
DEPEND="${RDEPEND}
	test? ( >=dev-cpp/gtest-1.8.0
		>=net-libs/grpc-1.15.0 )"

S=${WORKDIR}/${PN}-0.2

src_configure() {
	local mycmakeargs=(
		-DQT_PROTOBUF_MAKE_EXAMPLES=OFF
		-DQT_PROTOBUF_MAKE_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_test() {
	cd ${BUILD_DIR}
	ctest -R qtprotobuf_test
	ctest -R qtprotobuf_test_multifile
	ctest -R qtprotobuf_plugin_test
	ctest -R wellknowntypes_test
}
