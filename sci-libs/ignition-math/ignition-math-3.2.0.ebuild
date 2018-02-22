# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-multilib vcs-snapshot flag-o-matic

DESCRIPTION="A small, fast, and high performance math library for robot applications"
HOMEPAGE="https://ignitionrobotics.org/libraries/math"
SRC_URI="https://bitbucket.org/ignitionrobotics/ign-math/get/${PN}3_${PV}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="3/3"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}3_${PV}"
CMAKE_BUILD_TYPE=RelWithDebInfo

src_configure() {
	# upstream appends this conditionally...
	append-flags "-fPIC"
	echo "set (CMAKE_C_FLAGS_ALL \"${CXXFLAGS} \${CMAKE_C_FLAGS_ALL}\")" > "${S}/cmake/HostCFlags.cmake"
	sed -i -e "s/LINK_FLAGS_RELWITHDEBINFO \" \"/LINK_FLAGS_RELWITHDEBINFO \" ${LDFLAGS} \"/" cmake/DefaultCFlags.cmake || die
	cmake-multilib_src_configure
}
