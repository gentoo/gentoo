# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="AWS SDK for C++"
HOMEPAGE="https://github.com/aws/aws-sdk-cpp"
SRC_URI="https://github.com/aws/aws-sdk-cpp/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-cpp/aws-crt-cpp:=
	dev-libs/aws-c-auth:=
	dev-libs/aws-c-common:=
	dev-libs/aws-c-compression:=
	dev-libs/aws-c-event-stream:=
	dev-libs/aws-c-http:=
	dev-libs/aws-c-io:=
	dev-libs/aws-c-mqtt:=
	dev-libs/aws-c-s3:=
	dev-libs/aws-c-sdkutils:=
	dev-libs/aws-checksums:=
	net-misc/curl:=
	virtual/zlib:="
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/aws-c-common"

src_configure() {
	local mycmakeargs=(
		-DLEGACY_BUILD=ON
		-DBUILD_DEPS=OFF # disable embedded 3rd-party repositories.
	)

	cmake_src_configure
}
