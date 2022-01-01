# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="AWS SDK for C module, handles IO and TLS work for application protocols"
HOMEPAGE="https://github.com/awslabs/aws-c-io"
SRC_URI="https://github.com/awslabs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test"

RESTRICT="!test? ( test )"

BDEPEND="
	|| (
		>dev-util/cmake-3.19.1
		<dev-util/cmake-3.19.0
	)
"

DEPEND="
	>=dev-libs/aws-c-cal-0.4.5:=[static-libs=]
	>=dev-libs/aws-c-common-0.4.62:=[static-libs=]
	>=dev-libs/s2n-0.10.21:=[static-libs=]
"

PATCHES=(
	"${FILESDIR}"/${P}-cmake-prefix.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
