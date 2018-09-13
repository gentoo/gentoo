# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-r1

DESCRIPTION="High-performance regular expression matching library"
SRC_URI="https://github.com/01org/hyperscan/archive/v${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://01.org/hyperscan"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_ssse3 static-libs"

RDEPEND="${PYTHON_DEPS}
	dev-util/ragel
	dev-libs/boost
	net-libs/libpcap"
DEPEND="${RDEPEND}"

REQUIRED_USE="cpu_flags_x86_ssse3"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
		-DBUILD_STATIC_AND_SHARED=$(usex static-libs ON OFF)
	)
	cmake-utils_src_configure
}
