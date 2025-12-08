# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Crypto Abstraction Layer: Cross-Platform C99 wrapper for cryptography primitives"
HOMEPAGE="https://github.com/awslabs/aws-c-cal"
SRC_URI="https://github.com/awslabs/aws-c-cal/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake

LICENSE="Apache-2.0"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="dev-libs/aws-c-common:=
	dev-libs/openssl:="
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/aws-c-common"

src_configure()
{
	local mycmakeargs=(
		-DUSE_OPENSSL=ON
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
