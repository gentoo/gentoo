# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="s2n-tls is a C99 implementation of the TLS/SSL protocols"
HOMEPAGE="https://github.com/aws/s2n-tls"
SRC_URI="https://github.com/aws/s2n-tls/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"

IUSE="test"

DEPEND="dev-libs/openssl:="
RDEPEND="${DEPEND}"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/s2n-tls-1.6.0-cmake_version.patch"
	"${FILESDIR}/s2n-tls-1.6.0-cmake_LDFLAGS.patch"
)

src_configure()
{
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
	)

	cmake_src_configure
}
