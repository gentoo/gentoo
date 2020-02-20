# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="gRPC and Protobuf generator and bindings for Qt framework"
HOMEPAGE="https://semlanik.github.io/qtprotobuf/"
SRC_URI="https://github.com/semlanik/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-lang/go-1.10
	>=dev-libs/protobuf-3.6:=
	>=dev-qt/qtcore-5.12.3
	>=dev-qt/qtnetwork-5.12.3
	>=dev-qt/qtdeclarative-5.12.3"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DQTPROTOBUF_MAKE_TESTS=OFF
		-DQTPROTOBUF_MAKE_EXAMPLES=OFF
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}
