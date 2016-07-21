# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Cisco 7200/3600 Simulator"
HOMEPAGE="http://www.gns3.net/dynamips/"
SRC_URI="mirror://sourceforge/project/gns-3/Dynamips/${PV}/${P}-source.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="ipv6"

RDEPEND="dev-libs/elfutils
	net-libs/libpcap"
DEPEND="${RDEPEND}
	app-arch/unzip"

DOCS=( ChangeLog README RELEASE-NOTES )

S="${WORKDIR}"

PATCHES=( "${FILESDIR}/${PV}-docs.patch" )

src_prepare() {
	# comment out DYNAMIPS_FLAGS to respect CFLAGS
	sed -e "s:^set ( DYNAMIPS_FLAGS:#&:" -i cmake/dependencies.cmake || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable ipv6 IPV6)
	)
	cmake-utils_src_configure
}
