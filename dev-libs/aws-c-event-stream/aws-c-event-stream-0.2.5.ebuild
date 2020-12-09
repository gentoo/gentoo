# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="C99 implementation of the vnd.amazon.eventstream content-type"
HOMEPAGE="https://github.com/awslabs/aws-c-event-stream"
SRC_URI="https://github.com/awslabs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test"

RESTRICT="!test? ( test )"

BDEPEND="
	|| ( <dev-util/cmake-3.19.0
	     >dev-util/cmake-3.19.1 )
"

DEPEND="
	>=dev-libs/aws-c-common-0.4.62:=[static-libs=]
	>=dev-libs/aws-checksums-0.1.10:=[static-libs=]
"

PATCHES=(
	"${FILESDIR}"/0.1.3-add_missing_cmake_install_prefix.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
