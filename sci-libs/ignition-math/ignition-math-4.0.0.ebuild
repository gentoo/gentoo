# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-multilib vcs-snapshot flag-o-matic

DESCRIPTION="A small, fast, and high performance math library for robot applications"
HOMEPAGE="https://ignitionrobotics.org/libraries/math"
SRC_URI="https://bitbucket.org/ignitionrobotics/ign-math/get/${PN}4_${PV}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="4/4"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-util/ignition-cmake[${MULTILIB_USEDEP}]"
S="${WORKDIR}/${PN}4_${PV}"
CMAKE_BUILD_TYPE=RelWithDebInfo
