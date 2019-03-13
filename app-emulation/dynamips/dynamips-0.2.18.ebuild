# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Cisco 7200/3600 Simulator"
HOMEPAGE="https://github.com/GNS3/dynamips"
SRC_URI="https://github.com/GNS3/dynamips/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="ipv6"

RDEPEND="dev-libs/elfutils
	net-libs/libpcap"
DEPEND="${RDEPEND}
	app-arch/unzip"

DOCS=( ChangeLog README.md RELEASE-NOTES )

PATCHES=( "${FILESDIR}/${P}-docs.patch" )

src_prepare() {
	# comment out DYNAMIPS_FLAGS to respect CFLAGS
	sed -e "s:^set ( DYNAMIPS_FLAGS:#&:" -i cmake/dependencies.cmake || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DANY_COMPILER=1
		-DENABLE_IPV6="$(usex ipv6)"
	)
	cmake-utils_src_configure
}
