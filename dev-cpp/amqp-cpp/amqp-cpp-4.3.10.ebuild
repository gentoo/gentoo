# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS="cmake"
inherit cmake-multilib

MY_PN=${PN^^}
MY_P=${MY_PN}-${PV}

DESCRIPTION="AMQP-CPP is a C++ library for communicating with a RabbitMQ message broker"
HOMEPAGE="https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
SRC_URI="https://github.com/CopernicaMarketingSoftware/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed \
		-e "s:DESTINATION lib:DESTINATION $(get_libdir):g" \
		-e "s:DESTINATION cmake:DESTINATION $(get_libdir)/cmake/${PN/-/}:g" \
		-i CMakeLists.txt || die
	cmake_src_prepare
	default
}

src_configure() {
	local mycmakeargs=(
		-DAMQP-CPP_BUILD_SHARED=ON
		-DAMQP-CPP_LINUX_TCP=ON
	)
	cmake-multilib_src_configure
}
