# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils vcs-snapshot flag-o-matic

DESCRIPTION="Combines ZeroMQ with Protobufs to create a fast and efficient message passing system"
HOMEPAGE="http://ignitionrobotics.org/libraries/transport"
SRC_URI="http://gazebosim.org/distributions/ign-transport/releases/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0/0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/protobuf:=
	>=net-libs/zeromq-3.2.0:=
	sys-apps/util-linux
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	virtual/pkgconfig"
CMAKE_BUILD_TYPE=RelWithDebInfo

src_configure() {
	# upstream appends this conditionally...
	append-flags "-fPIC"
	echo "set (CMAKE_C_FLAGS_ALL \"${CXXFLAGS} \${CMAKE_C_FLAGS_ALL}\")" > "${S}/cmake/HostCFlags.cmake"
	sed -i -e "s/LINK_FLAGS_RELWITHDEBINFO \" \"/LINK_FLAGS_RELWITHDEBINFO \" ${LDFLAGS} \"/" cmake/DefaultCFlags.cmake || die
	cmake-utils_src_configure
}
