# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Combines ZeroMQ with Protobufs to create a message passing system"
HOMEPAGE="https://github.com/ignitionrobotics/ign-transport"
SRC_URI="https://github.com/ignitionrobotics/ign-transport/archive/${PN}8_${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="8"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	net-libs/ignition-msgs:5=
	dev-libs/protobuf:=
	>=net-libs/zeromq-4.2.0:=
	sys-apps/util-linux
	net-libs/cppzmq
	dev-db/sqlite:3
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-util/ignition-cmake:2"
BDEPEND="
	dev-util/ignition-cmake:2
	virtual/pkgconfig"
CMAKE_BUILD_TYPE=RelWithDebInfo
S="${WORKDIR}/gz-transport-ignition-transport8_${PV}"
