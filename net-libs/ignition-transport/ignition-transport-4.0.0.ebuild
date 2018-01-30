# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils vcs-snapshot flag-o-matic

DESCRIPTION="Combines ZeroMQ with Protobufs to create a fast and efficient message passing system"
HOMEPAGE="http://ignitionrobotics.org/libraries/transport"
SRC_URI="http://gazebosim.org/distributions/ign-transport/releases/${PN}4-${PV}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="4/4"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	net-libs/ignition-msgs:1=
	dev-libs/protobuf:=
	>=net-libs/zeromq-3.2.0:=
	sys-apps/util-linux
	net-libs/cppzmq
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	>=dev-util/ignition-cmake-0.4
	virtual/pkgconfig"
CMAKE_BUILD_TYPE=RelWithDebInfo
S="${WORKDIR}/${PN}4-${PV}"
PATCHES=( "${FILESDIR}/zmq.patch" )
